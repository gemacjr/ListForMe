//
//  SignUpViewController.swift
//  Listin
//
//  Created by Ed McCormic on 7/17/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import KRProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loginView.layer.cornerRadius = 8
        loginView.layer.borderWidth = 1
        
        signUpButtonOutlet.layer.cornerRadius = 8
        signUpButtonOutlet.layer.borderWidth = 1
        signUpButtonOutlet.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        signInButtonOutlet.layer.cornerRadius = 8
        signInButtonOutlet.layer.borderWidth = 1
        
        
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        firstNameTextField.layer.cornerRadius = 8
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        lastNameTextField.layer.cornerRadius = 8
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        
        
    }
    
    //dismiss keyboard
    
    //MARK: IBActions

    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {
            
            KRProgressHUD.show(withMessage: "Signing up...")
            
            FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, completion: { (error) in
                
                if error != nil {
                    
                    KRProgressHUD.showError(withMessage: "Error couldn't register")
                    return
                }
                
                self.goToApp()
                
            })
            
        } else {
            KRProgressHUD.showError(withMessage: "All fields are required")
        }
        
    }
    

    @IBAction func signInButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Go to App
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
