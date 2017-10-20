//
//  JobViewController.swift
//  Tracker
//
//  Created by Andy LI on 10/3/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class JobViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var jobNameTextField: UITextField!
    @IBOutlet weak var jobRequestorTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var jobIndex: Int?
    var addMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(JobViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        jobNameTextField.delegate = self
        jobRequestorTextField.delegate = self
        jobDescriptionTextView.delegate = self
        
        // If editing a job, load job info
        
        if let jobIndex = jobIndex{
            let job = AppArrayManager.AppArray[jobIndex]
            navigationItem.title = job.name
            jobNameTextField.text = job.name
            jobRequestorTextField.text = job.requestor
            jobDescriptionTextView.text = job.desc
        }
            
        else{
            navigationItem.title = "Adding new job"
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
            let jobTVC = self.navigationController?.topViewController as! JobsTableViewController
            jobTVC.reloadTable()
        }
    }
    
    // MARK: Actions
    
    @IBAction func jobSave(_ sender: UIBarButtonItem) {
        let goodName = isGoodName()
        let goodRequestor = isGoodRequestor()
        let goodDescription = isGoodDescription()
        
        if(goodName && goodRequestor && goodDescription){
            
            let job = Job(name: jobNameTextField.text!, requestor: jobRequestorTextField.text, description: jobDescriptionTextView.text)
            
            if self.addMode{
                //Will be adding a new item
                AppArrayManager.AppArray.append(job)
            }
            else{
                //Updating previous item
                AppArrayManager.AppArray[jobIndex!].name = job.name
                AppArrayManager.AppArray[jobIndex!].requestor = job.requestor
                AppArrayManager.AppArray[jobIndex!].desc = job.desc
            }
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {}
            self.navigationController?.popViewController(animated: true)
            if(addMode){
                let jobTVC = self.navigationController?.topViewController as! JobsTableViewController
                jobTVC.reloadTable()
            }
            else{
                let projectTVC = self.navigationController?.topViewController as! ProjectsTableViewController
                projectTVC.navigationItem.title = job.name
                projectTVC.reloadTable()
            }
            AppArrayManager.saveAppArray()
        }
        else{
            var errorMessage = ""
            if(!goodName){
                errorMessage += "Job Name must be under 30 characters. \n"
            }
            if(!goodRequestor){
                errorMessage += "Job Requestor must be under 30 characters. \n"
            }
            if(!goodDescription){
                errorMessage += "Job Description must be under 200 characters."
            }
            let alert = UIAlertController(title: "Invalid Input", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let name = jobNameTextField.text ?? ""
        
        saveButton.isEnabled = !name.isEmpty
    }
    
    private func isGoodName() -> Bool{
        //make sure it does not exceed 30 charaters, could be set to more in future
        let name = jobNameTextField.text ?? ""
        if(name.count <= 30){
            return true
        }
        return false
    }
    private func isGoodRequestor() -> Bool{
        //make sure it does not exceed 30 characters, could be set to more in future
        let requestor = jobRequestorTextField.text ?? ""
        if(requestor.count <= 30){
            return true
        }
        return false
    }
    private func isGoodDescription() -> Bool{
        //make sure it does not exceed 200 characters, could be set to more in future
        let desc = jobDescriptionTextView.text ?? ""
        if(desc.count <= 200){
            return true
        }
        return false
    }
}
