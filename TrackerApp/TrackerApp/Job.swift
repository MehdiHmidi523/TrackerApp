//
//  Job.swift
//  Tracker
//
//  Created by Andy LI on 10/3/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log
class Job: NSObject, NSCoding{
    
    //MARK: Properties
    
    var name: String
    var requestor: String?
    var desc: String?
    var totalCost: Double = 0
    var Projects: [Project] = []
    
    struct PropertyKey {
        static let name = "jobName"
        static let requestor = "jobRequestor"
        static let description = "jobDescription"
        static let projects = "jobProjects"
    }
    
    init(name: String, requestor: String?, description: String?) {
        self.name = name
        self.requestor = requestor
        self.desc = description
    }
    init(name: String, requestor: String?, description: String?, projects: [Project]) {
        self.name = name
        self.requestor = requestor
        self.desc = description
        self.Projects = projects
    }
    
    func updateTotalCost() {
        totalCost = 0
        for Project in Projects{
            totalCost += Project.totalCost
        }
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(requestor, forKey: PropertyKey.requestor)
        aCoder.encode(description, forKey: PropertyKey.description)
        aCoder.encode(Projects, forKey: PropertyKey.projects)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a job.", log: OSLog.default, type: .debug)
            return nil
        }
        let requestor = aDecoder.decodeObject(forKey: PropertyKey.requestor) as? String
        let description = aDecoder.decodeObject(forKey: PropertyKey.description) as? String
        let projects = aDecoder.decodeObject(forKey: PropertyKey.projects) as? [Project]

        // Must call designated initializer.
        self.init(name: name, requestor: requestor, description: description, projects: projects!)
        self.updateTotalCost()
    }
}
