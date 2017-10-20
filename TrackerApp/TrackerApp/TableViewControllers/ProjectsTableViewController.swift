//
//  ProjectsTableViewController.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class ProjectsTableViewController: UITableViewController {

    /*
     This value is either passed by `JobsTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     
     Used jobIndex so that we can save to AppArrayManager from here
     */
    var jobIndex: Int?
    var projects = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //back button to return to projects and reload that page
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProjectsTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        let job = AppArrayManager.AppArray[jobIndex!]
        projects += job.Projects
        navigationItem.title = job.name
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    
    func reloadTable(){
        //reload the table when returning to page
        let job = AppArrayManager.AppArray[jobIndex!]
        projects = job.Projects
        self.tableView.reloadData()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {}
        self.navigationController?.popViewController(animated: true)
        let jobTVC = self.navigationController?.topViewController as! JobsTableViewController
        jobTVC.reloadTable();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "ProjectsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath) as? ProjectsTableViewCell else {
            fatalError("The dequed cell is not an instance of ProjectsTableViewCell.")
        }
        
        let project = projects[indexPath.row]
        
        cell.projectNameLabel.text = project.name
        cell.numItemLabel.text = "Number of Items: " + String(project.Items.count)
        var isCents = ""
        if Int(project.totalCost*100) % 10 == 0{
            isCents = "0"
        }
        cell.projectsTotalCostLabel.text = "Total Cost: $" + String(project.totalCost) + isCents
        
        return cell
    }

    // MARK: Actions
    
    @IBAction func deleteJob(_ sender: UIBarButtonItem) {
        
        let myAlertController: UIAlertController = UIAlertController(title: "Deleting Job", message: "Are you sure you want to delete this entire job. (This will also delete all the projects and items within the job) ", preferredStyle: .alert)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            AppArrayManager.AppArray.remove(at: self.jobIndex!)
            self.navigationController?.popViewController(animated: true)
            let jobTVC = self.navigationController?.topViewController as! JobsTableViewController
            jobTVC.reloadTable()
            AppArrayManager.saveAppArray()
        }
        myAlertController.addAction(deleteAction)

        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: .cancel) { action -> Void in
        }
        myAlertController.addAction(cancelAction)
        
        //Present the AlertController
        self.present(myAlertController, animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddProject":
            guard let projectDetailViewController = segue.destination as? ProjectViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            projectDetailViewController.jobIndex = jobIndex
            projectDetailViewController.addMode = true
            
        case "ShowItems":
            guard let projectItemsViewController = segue.destination as? ItemsTableViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedProjectCell = sender as? ProjectsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedProjectCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            projectItemsViewController.projectIndex = indexPath.row
            projectItemsViewController.jobIndex = jobIndex
            
        case "JobDetails":
            guard let jobViewController = segue.destination as? JobViewController
                else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            jobViewController.jobIndex = jobIndex
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

}
