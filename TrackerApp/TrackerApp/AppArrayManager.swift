//
//  AppArrayManager.swift
//  Tracker
//
//  Created by Andy LI on 10/3/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class AppArrayManager: NSObject, NSCoding {
    
    //MARK: Property
    
    static var AppArray: [Job] = []
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Jobs")
    
    //This is where we will save and load the data for the app
    
    init(array: [Job]){
        AppArrayManager.AppArray = array
    }
    
    static func saveAppArray() {
        //Save the app array
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(AppArrayManager.AppArray, toFile: AppArrayManager.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Jobs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Jobs...", log: OSLog.default, type: .error)
        }
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(AppArrayManager.AppArray, forKey: "AppArray")
    }
    required convenience init?(coder decoder: NSCoder) {
        let array:[Job] = []
        self.init(array: array)
    }
}
