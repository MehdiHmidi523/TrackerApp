//
//  HomeViewController.swift
//  Tracker
//
//  Created by Andy LI on 9/8/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Homepage is only used to show title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedJobs = loadJobs() {
            loadSampleJobs()
            AppArrayManager.AppArray += savedJobs
        }
        else {
            // Load the sample data.
            loadSampleJobs()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func loadJobs() -> [Job]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: AppArrayManager.ArchiveURL.path) as? [Job]
    }
    private func loadSampleJobs(){
        //Sample Jobs, Projects, Items that are loaded by default when app is first run
        
        //***************** PUT IN PICTURES *******************
        let tempphoto = UIImage()
        
        let Job1 = Job(name: "House", requestor: "Tommy", description: "In Minneapolis - 2 bedroom - 2 bath")
        let Project1 = Project(name: "1st Floor Flooring", leader: "Leader 1", description: "Hardwood")
        let Item1 = Item(name: "Hardwood 1x6x12", quantity: 5, cost: 7.05, photo: tempphoto)
        
        Project1?.Items.append(Item1!)
        Project1?.updateTotalCost()
        Job1.Projects.append(Project1!)
        Job1.updateTotalCost()
        
        let Job2 = Job(name: "Bridge", requestor: "City Hall", description: "Over Mississippi River - 1/2 mile")
        
        let Project2 = Project(name: "Suspension", leader: "Leader 1", description: "Support")
        let Item2 = Item(name: "Cables", quantity: 100, cost: 123.45, photo: tempphoto)
        let Item3 = Item(name: "Bolts", quantity: 200, cost: 0.50, photo: tempphoto)
        
        let Project3 = Project(name: "Road painting", leader: "Leader 1", description: "Marks on road")
        let Item4 = Item(name: "Yellow Paint Buckets", quantity: 10, cost: 19.25, photo: tempphoto)
        let Item5 = Item(name: "White Pain Buckets", quantity: 20, cost: 19.25, photo: tempphoto)
        let Item6 = Item(name: "Orange Cones", quantity: 30, cost: 9.99, photo: tempphoto)
        
        Project2?.Items.append(Item2!)
        Project2?.Items.append(Item3!)
        Project2?.updateTotalCost()
        
        Project3?.Items.append(Item4!)
        Project3?.Items.append(Item5!)
        Project3?.Items.append(Item6!)
        Project3?.updateTotalCost()
        
        Job2.Projects.append(Project2!)
        Job2.Projects.append(Project3!)
        Job2.updateTotalCost()
        
        AppArrayManager.AppArray += [Job1,Job2]
    }
}

