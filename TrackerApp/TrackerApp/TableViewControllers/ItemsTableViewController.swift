//
//  ItemsTableViewController.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class ItemsTableViewController: UITableViewController {

    var projectIndex: Int?
    var jobIndex: Int?
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back button to return to projects and reload that page
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemsTableViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        let project = AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!]
        items = project.Items
        navigationItem.title = project.name
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    func reloadTable(){
        //reload the table when returning to page
        let project = AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!]
        items = project.Items
        self.tableView.reloadData()
    }
    @objc func back(sender: UIBarButtonItem) {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {}
        self.navigationController?.popViewController(animated: true)
        let projectTVC = self.navigationController?.topViewController as! ProjectsTableViewController
        projectTVC.reloadTable();
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ItemsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath) as? ItemsTableViewCell else {
            fatalError("The dequed cell is not an instance of ItemsTableViewCell.")
        }
        
        let item = items[indexPath.row]
        
        cell.itemNameLabel.text = item.name
        cell.itemQuantityLabel.text = "Quantity: " + String(item.quantity)

        //adding 0 to the end of doubles that don't have cents
        var isCents = ""
        if Int(item.cost*100) % 10 == 0{
            isCents = "0"
        }
        cell.itemCostLabel.text = "Cost: $" + String(item.cost) + isCents
        
        isCents = ""
        if Int(item.totalCost*100) % 10 == 0{
            isCents = "0"
        }
        
        cell.itemTotalCostLabel.text = "Total Cost: $" + String(item.totalCost) + isCents

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].Items.remove(at: indexPath.row)
           AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].updateTotalCost()
            AppArrayManager.AppArray[jobIndex!].updateTotalCost()
            
                items = AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].Items
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //MARK: Actions
    
    @IBAction func deleteProject(_ sender: UIBarButtonItem) {
        let myAlertController: UIAlertController = UIAlertController(title: "Deleting Project", message: "Are you sure you want to delete this entire project. (This will also delete all the items within the project) ", preferredStyle: .alert)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action -> Void in
            AppArrayManager.AppArray[self.jobIndex!].Projects.remove(at: self.projectIndex!)
            AppArrayManager.AppArray[self.jobIndex!].updateTotalCost()
            self.navigationController?.popViewController(animated: true)
            let projectTVC = self.navigationController?.topViewController as! ProjectsTableViewController
            projectTVC.reloadTable()
            AppArrayManager.saveAppArray()
        }
        myAlertController.addAction(deleteAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: .cancel) { action -> Void in
        }
        myAlertController.addAction(cancelAction)
        
        //Present the AlertController
        self.present(myAlertController, animated: true, completion: nil)
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {

        case "AddItem":
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
            guard let itemDetailViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            itemDetailViewController.projectIndex = projectIndex
            itemDetailViewController.jobIndex = jobIndex
            itemDetailViewController.addMode = true
            
        case "ShowDetail":
            guard let itemDetailViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? ItemsTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            itemDetailViewController.itemIndex = indexPath.row
            itemDetailViewController.projectIndex = projectIndex
            itemDetailViewController.jobIndex = jobIndex
            
        case "ProjectDetails":
            guard let projectViewController = segue.destination as? ProjectViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            projectViewController.jobIndex = jobIndex
            projectViewController.projectIndex = projectIndex
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
