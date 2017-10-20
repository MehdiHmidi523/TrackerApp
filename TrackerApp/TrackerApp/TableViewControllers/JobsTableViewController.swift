//
//  JobsTableViewController.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class JobsTableViewController: UITableViewController {

    //MARK: Properties
    
    var jobs = [Job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBackButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(JobsTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        jobs = AppArrayManager.AppArray
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    
    func reloadTable(){
        //reload the table when returning to page
        jobs = AppArrayManager.AppArray
        self.tableView.reloadData()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "JobsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath) as? JobsTableViewCell else {
            fatalError("The dequed cell is not an instance of JobTableViewCell.")
        }
        
        let job = jobs[indexPath.row]
        
        cell.jobNameLabel.text = job.name
        cell.numProjLabel.text = "Number of Projects: " + String(job.Projects.count)
        var isCents = ""
        if Int(job.totalCost*100) % 10 == 0{
            isCents = "0"
        }
        cell.jobTotalCostLabel.text = "Total Cost: $" + String(job.totalCost) + isCents

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "AddJob":
            guard let jobViewController = segue.destination as? JobViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            jobViewController.addMode = true
            
        case "ShowProjects":
            guard let jobProjectsViewController = segue.destination as? ProjectsTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedJobCell = sender as? JobsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedJobCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            jobProjectsViewController.jobIndex = indexPath.row
            
        case "ShowHomepage":
            os_log("Going home.", log: OSLog.default, type: .info)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
