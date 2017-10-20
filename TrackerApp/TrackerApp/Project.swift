//
//  Project.swift
//  Tracker
//
//  Created by Andy LI on 10/3/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class Project: NSObject, NSCoding {
    
    var Items: [Item] = []
    
    var name: String
    var totalCost: Double = 0
    var leader: String?
    var desc: String?
    
    struct PropertyKey {
        static let name = "projectName"
        static let leader = "projectLeader"
        static let description = "projectDescription"
        static let items = "projectItems"
    }
    
    init?(name: String, leader: String?, description: String?) {
        self.name = name
        self.leader = leader
        self.desc = description
    }
    
    init?(name: String, leader: String?, description: String?, items: [Item]) {
        self.name = name
        self.leader = leader
        self.desc = description
        self.Items = items
    }
    
    func updateTotalCost() {
        totalCost = 0
        for Item in Items{
            Item.updateTotalCost()
            totalCost += Item.totalCost
        }
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(leader, forKey: PropertyKey.leader)
        aCoder.encode(description, forKey: PropertyKey.description)
        aCoder.encode(Items, forKey: PropertyKey.items)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a project.", log: OSLog.default, type: .debug)
            return nil
        }
        let leader = aDecoder.decodeObject(forKey: PropertyKey.leader) as? String
        let description = aDecoder.decodeObject(forKey: PropertyKey.description) as? String
        let items = aDecoder.decodeObject(forKey: PropertyKey.items) as? [Item]
        // Must call designated initializer.
        self.init(name: name, leader: leader, description: description, items: items!)
        self.updateTotalCost()
    }
}
