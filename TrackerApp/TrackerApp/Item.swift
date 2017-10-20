//
//  Item.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class Item: NSObject, NSCoding{
    
    //MARK: Properties
    
    var name: String
    var quantity: Int
    var cost: Double
    var photo: UIImage?
    var totalCost: Double = 0
    
    struct PropertyKey {
        static let name = "itemName"
        static let quantity = "itemQuantity"
        static let cost = "itemCost"
        static let photo = "itemPhoto"
    }
    //MARK: Initialization
    
    init?(name: String, quantity: Int, cost: Double, photo: UIImage?) {

        self.name = name
        self.quantity = quantity
        self.cost = cost
        self.photo = photo
    }
    
    func updateTotalCost() {
        self.totalCost = Double(self.quantity) * self.cost
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(quantity, forKey: PropertyKey.quantity)
        aCoder.encode(cost, forKey: PropertyKey.cost)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
            os_log("Unable to decode the name for an item.", log: OSLog.default, type: .debug)
            return nil
        }
        let quantity = aDecoder.decodeInteger(forKey: PropertyKey.quantity)
        let cost = aDecoder.decodeDouble(forKey: PropertyKey.cost)
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, quantity: quantity, cost: cost, photo: photo)
        self.updateTotalCost()
    }
}
