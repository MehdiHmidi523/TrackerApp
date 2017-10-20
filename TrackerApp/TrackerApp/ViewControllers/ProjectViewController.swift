//
//  ProjectViewController.swift
//  Tracker
//
//  Created by Andy LI on 10/3/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class ProjectViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectLeaderTextField: UITextField!
    @IBOutlet weak var projectDescriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var jobIndex: Int?
    var projectIndex: Int?
    var addMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        projectNameTextField.delegate = self
        projectLeaderTextField.delegate = self
        projectDescriptionTextView.delegate = self
        
        // If editing a project, load project info
        
        if let projectIndex = projectIndex{
            let project = AppArrayManager.AppArray[jobIndex!].Projects[projectIndex]
            navigationItem.title = project.name
            projectNameTextField.text = project.name
            projectLeaderTextField.text = project.leader
            projectDescriptionTextView.text = project.desc
        }
        
        else{
            navigationItem.title = "Adding new Project"
        }
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    
    // MARK: - Navigation
    
    @objc func back(sender: UIBarButtonItem) {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {}
        self.navigationController?.popViewController(animated: true)
        if(addMode){
            let projectTVC = self.navigationController?.topViewController as! ProjectsTableViewController
            projectTVC.reloadTable()
        }
    }
    
    // MARK: Actions
    
    @IBAction func projectSave(_ sender: UIBarButtonItem) {
        let goodName = isGoodName()
        let goodLeader = isGoodLeader()
        let goodDescription = isGoodDescription()
        
        if(goodName && goodLeader && goodDescription){
            
            let project = Project(name: projectNameTextField.text!, leader: projectLeaderTextField.text, description: projectDescriptionTextView.text)
            
            if self.addMode{
                //Will be adding a new item
                AppArrayManager.AppArray[jobIndex!].Projects.append(project!)
                AppArrayManager.AppArray[jobIndex!].updateTotalCost()
            }
            else{
                //Updating previous item
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].name = project!.name
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].leader = project!.leader
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].desc = project!.description
                AppArrayManager.AppArray[jobIndex!].updateTotalCost()
            }
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {}
            self.navigationController?.popViewController(animated: true)
            if(addMode){
                let projectTVC = self.navigationController?.topViewController as! ProjectsTableViewController
                projectTVC.reloadTable()
            }
            else{
                let itemTVC = self.navigationController?.topViewController as! ItemsTableViewController
                itemTVC.navigationItem.title = project!.name
                itemTVC.reloadTable()
            }
            AppArrayManager.saveAppArray()
        }
        else{
            var errorMessage = ""
            if(!goodName){
                errorMessage += "Project Name must be under 30 characters. \n"
            }
            if(!goodLeader){
                errorMessage += "Project Leader must be under 30 characters. \n"
            }
            if(!goodDescription){
                errorMessage += "Project Description must be under 200 characters."
            }
            let alert = UIAlertController(title: "Invalid Input", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let name = projectNameTextField.text ?? ""

        saveButton.isEnabled = !name.isEmpty
    }
    
    private func isGoodName() -> Bool{
        //make sure it does not exceed 30 charaters, could be set to more in future
        let name = projectNameTextField.text ?? ""
        if(name.count <= 30){
            return true
        }
        return false
    }
    private func isGoodLeader() -> Bool{
        //make sure it does not exceed 30 characters, could be set to more in future
        let leader = projectLeaderTextField.text ?? ""
        if(leader.count <= 30){
            return true
        }
        return false
    }
    private func isGoodDescription() -> Bool{
        //make sure it does not exceed 200 characters, could be set to more in future
        let desc = projectDescriptionTextView.text ?? ""
        if(desc.count <= 200){
            return true
        }
        return false
    }
}
