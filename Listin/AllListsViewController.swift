//
//  AllListsViewController.swift
//  Listin
//
//  Created by Ed McCormic on 7/12/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import KRProgressHUD

class AllListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var allLists:[ShoppingList] = []
    
    var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //KRProgressHUD.set(activityIndicatorViewStyle: .gradationColor(head: <#T##UIColor#>, tail: <#T##UIColor#>))
        
        KRProgressHUD.dismiss()
        
        loadLists()

        navigationController?.navigationBar.barTintColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0)
        
       
        
    }

    
    
    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        
        let shoppingList = allLists[indexPath.row]
        
        
        //cell.textLabel?.text = shoppingList.name
        
        cell.bindData(item: shoppingList)
        
        
        return cell
    }
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "shoppingListToShoppingItemSegue", sender: indexPath)
        
        
    }
    
    
    //MARK: IBActions
    
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Create Shopping List", message: "Enter shopping list name", preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            
            
            self.nameTextField = nameTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if self.nameTextField.text != "" {
                
                self.createShoppingList()
                
            }else {
                
                KRProgressHUD.showWarning(withMessage: "Name is empty!")
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    //MARK: LoadList
    
    func loadLists() {
        
        firebase.child(kSHOPPINGLIST).child(FUser.currentId()).observe(.value, with: {
            
            snapshot in
            
            self.allLists.removeAll()
            
            if snapshot.exists() {
                
                let sorted = ((snapshot.value as! NSDictionary).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])
                
                for list in sorted {
                    
                    let currentList = list as! NSDictionary
                    
                    self.allLists.append(ShoppingList.init(dictionary: currentList))
                }
                
                
            }else {
                print("no snapshot")
            }
            
            self.tableView.reloadData()
        })
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shoppingListToShoppingItemSegue" {
            
            let indexPath = sender as! IndexPath
            let shoppingList = allLists[indexPath.row]
            
            let vc = segue.destination as! ShoppingItemViewViewController
            
            vc.shoppingList = shoppingList
            
        }
    }
    
    
    
    //MARK: Helper functions
    
    func createShoppingList() {
        
        let shoppingList = ShoppingList(_name: nameTextField.text!)
        
        shoppingList.saveItemInBackground(shoppingList: shoppingList) { (error) in
            
            if error != nil {
                
                KRProgressHUD.showError(withMessage: "Error creating shopping list")
                
                return
            }
        }
        
    }
    
    
    


}
