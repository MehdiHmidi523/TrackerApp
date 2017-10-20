//
//  ItemViewController.swift
//  Tracker
//
//  Created by Andy LI on 9/27/17.
//  Copyright © 2017 Puzzle. All rights reserved.
//

import UIKit
import os.log

class ItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is passed to ItemTableViewController in prepare(for:sender:) or constructed as part ofadding a new meal.
     */

    var jobIndex: Int?
    var projectIndex: Int?
    var itemIndex: Int?
    var item: Item?
    var addMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        nameTextField.delegate = self
        quantityTextField.delegate = self
        costTextField.delegate = self
        
        // If editing an item, load item info
        
        if let itemIndex = itemIndex{
            
            let item = AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].Items[itemIndex]
            navigationItem.title = item.name
            nameTextField.text = item.name
            quantityTextField.text = String(item.quantity)
            costTextField.text = String(item.cost)
            photoImageView.image = item.photo
        }
        else{
            navigationItem.title = "Adding New Item"
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    @objc func back(sender: UIBarButtonItem) {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {}
        self.navigationController?.popViewController(animated: true)
        let itemTVC = self.navigationController?.topViewController as! ItemsTableViewController
        itemTVC.reloadTable();
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
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
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func itemSave(_ sender: UIBarButtonItem) {
        let goodName = isGoodName()
        let goodCost = isGoodCost()
        let goodQuantity = isGoodQuantity()
        
        if(goodName && goodCost && goodQuantity){
        
            let item = Item(name: nameTextField.text!, quantity: Int(quantityTextField.text!)!, cost: Double(costTextField.text!)!, photo: photoImageView.image)
            
            if self.addMode{
                //Will be adding a new item
                item?.updateTotalCost()
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].Items.append(item!)
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].updateTotalCost()
                AppArrayManager.AppArray[jobIndex!].updateTotalCost()
            }
            else{
                //Updating previous item
                item?.updateTotalCost()
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].Items[itemIndex!] = item!
                AppArrayManager.AppArray[jobIndex!].Projects[projectIndex!].updateTotalCost()
                AppArrayManager.AppArray[jobIndex!].updateTotalCost()
            }
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {}
            self.navigationController?.popViewController(animated: true)
            let itemTVC = self.navigationController?.topViewController as! ItemsTableViewController
            itemTVC.reloadTable();
            AppArrayManager.saveAppArray()
        }
        else{
            var errorMessage = ""
            if(!goodName){
                errorMessage += "The name must be under 30 characters. \n"
            }
            if(!goodQuantity){
                errorMessage += "The quantity must be between 0 and 1,000,000 \n"
            }
            if(!goodCost){
                errorMessage += "The cost must be between between 0 and 1,000,000 with a maximum 2 decimal places"
            }
            let alert = UIAlertController(title: "Invalid Input", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let name = nameTextField.text ?? ""
        let quantity = quantityTextField.text ?? ""
        let cost = costTextField.text ?? ""
        
        saveButton.isEnabled = !name.isEmpty && Int(quantity) != nil && Double(cost) != nil
    }
    
    private func isGoodName() -> Bool{
        //make sure it does not exceed 30 characters, could be set to more in future
        let name = nameTextField.text ?? ""
        if(name.count <= 30){
            return true
        }
        return false
    }
    private func isGoodQuantity() -> Bool{
        //make sure that it is not a decimal and is >= 0
        let quantity = Int(quantityTextField.text ?? "")
        let dquantity = Double(quantityTextField.text ?? "")
        if(quantity! >= 0 && quantity! < 1000000 && Double(quantity!) == dquantity){
            return true
        }
        return false
    }
    private func isGoodCost() -> Bool{
        //make sure that it doesn't exceed 2 decimal places and is >= 0
        let cost = Double(costTextField.text ?? "")
        let icost = Int(cost! * 100)
        let dcost = Double(icost) / 100
        if(cost! >= 0 && cost! < 1000000 && cost == dcost){
            return true
        }
        return false
        
    }
}
