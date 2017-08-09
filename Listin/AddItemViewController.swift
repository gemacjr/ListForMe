//
//  AddItemViewController.swift
//  Listin
//
//  Created by Ed McCormic on 7/15/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var extraInfoTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    
    var shoppingList: ShoppingList!
    
    var itemImage: UIImage!
    
    var shoppingItem: ShoppingItem!
    
    var addingToList: Bool?
    
    var groceryItem: GroceryItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
        itemImageView.image = image.circleMasked
        
        if shoppingItem != nil || groceryItem != nil {
            updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: IBAction

    @IBAction func addImageButton(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = Camera(delegate_: self)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert) in
            
            camera.PresentPhotoCamera(target: self, canEdit: true)
            
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if nameTextField.text != "" && priceTextField.text != "" {
            
            if shoppingItem != nil || groceryItem != nil {
                
                self.updateItem()
                
            } else {
                saveItem()
            }
            
            
            
        }else {
            
            KRProgressHUD.showWarning(withMessage: "Empty fields!")
        }
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Saving Item
    
    func updateItem() {
        
        var imageData: String!
        
        if itemImage != nil {
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)
            imageData = image?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            
        }else {
            imageData = ""
        }
        
        if shoppingItem != nil {
            
            shoppingItem!.name = nameTextField.text!
            shoppingItem!.price = Float(priceTextField.text!)!
            shoppingItem!.quantity = quantityTextField.text!
            shoppingItem!.info = extraInfoTextField.text!
            
            shoppingItem!.image = imageData
            
            shoppingItem?.updateItemInBackground(shoppingItem: shoppingItem!, completion: { (error) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error updating shopping item")
                    return
                }
            })
            
            KRProgressHUD.showInfo(withMessage: "Shopping Item updated!")
            
        } else if groceryItem != nil {
            
            groceryItem!.name = nameTextField.text!
            groceryItem!.price = Float(priceTextField.text!)!
            
            groceryItem!.info = extraInfoTextField.text!
            
            groceryItem!.image = imageData
            
            groceryItem?.updateItemInBackground(groceryItem: groceryItem!, completion: { (error) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error updating grocery item")
                    return
                }
            })
            
            KRProgressHUD.showInfo(withMessage: "Grocery Item updated!")
        }
        
        
        
    }
    
    func saveItem(){
        
        var shoppingItem: ShoppingItem
        
        
        var imageData: String!
        
        if itemImage != nil {
            
            let image = UIImageJPEGRepresentation(itemImage!, 0.5)
            imageData = image?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        }else {
            
            imageData = ""
        }
        
        if addingToList! {
            
            //add to grocerylist only
            shoppingItem = ShoppingItem(_name: nameTextField.text!, _info: extraInfoTextField.text!, _price: Float(priceTextField.text!)!, _shoppingListId: "")
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            
            groceryItem.image = imageData
            
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error saving grocery item")
                    return
                }
            })
            
            KRProgressHUD.showSuccess()
            self.dismiss(animated: true, completion: nil)
            
            
        }else {
            
            let shoppingItem = ShoppingItem(_name: nameTextField.text!, _info: extraInfoTextField.text!, _quantity: quantityTextField.text!, _price: Float(priceTextField.text!)!, _shoppingListId: shoppingList.id)
            
            shoppingItem.image = imageData
            
            shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error saving shopping item")
                    return
                }
            }
            
            showListNotification(shoppingItem: shoppingItem)
            
        }
        
        
        KRProgressHUD.showInfo(withMessage: "Shopping Item saved")
    
    }
    
    func showListNotification(shoppingItem: ShoppingItem){
        
        
        let alertController = UIAlertController(title: "Shopping Items", message: "Do you want to add this item to your items?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error creating grocery item")
                }
            })
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: UIImagePickerController deleagte
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.itemImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
        
        let newImage = itemImage!.scaleImageToSize(newSize: itemImageView.frame.size)
        
        self.itemImageView.image = newImage.circleMasked
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UpdateUI
    
    func updateUI() {
        
        if shoppingItem != nil {
            
            self.nameTextField.text = self.shoppingItem!.name
            self.extraInfoTextField.text = self.shoppingItem!.info
            self.quantityTextField.text = self.shoppingItem!.quantity
            self.priceTextField.text = "\(self.shoppingItem!.price)"
            
            if shoppingItem!.image != "" {
                imageFromData(pictureData: shoppingItem!.image, withBlock: { (image) in
                    self.itemImage = image!
                    
                    let newImage = image!.scaleImageToSize(newSize: itemImageView.frame.size)
                    self.itemImageView.image = newImage.circleMasked
                })
            }
        } else if groceryItem != nil {
            
            self.nameTextField.text = self.groceryItem!.name
            self.extraInfoTextField.text = self.groceryItem!.info
            self.quantityTextField.text = ""
            self.priceTextField.text = "\(self.groceryItem!.price)"
            
            if groceryItem!.image != "" {
                imageFromData(pictureData: groceryItem!.image, withBlock: { (image) in
                    self.itemImage = image!
                    
                    let newImage = image!.scaleImageToSize(newSize: itemImageView.frame.size)
                    self.itemImageView.image = newImage.circleMasked
                })
            }
            
        }
    }
   
}
