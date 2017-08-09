//
//  LoginViewController.swift
//  Listin
//
//  Created by Ed McCormic on 7/17/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import KRProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginMainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginMainView.layer.cornerRadius = 8
        loginMainView.layer.borderWidth = 1
        loginMainView.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        signInButtonOutlet.layer.cornerRadius = 8
        signInButtonOutlet.layer.borderWidth = 1
        signInButtonOutlet.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        signUpButtonOutlet.layer.cornerRadius = 8
        signUpButtonOutlet.layer.borderWidth = 1
        
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor(red: 102/255, green: 152/255, blue: 179/255, alpha: 1.0).cgColor
        

        
    }
    
    //MARK: IBAction
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            KRProgressHUD.show(withMessage: "Signing in...")
            
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!, completion: { (error) in
                
                if error != nil {
                    KRProgressHUD.showError(withMessage: "Error login in!")
                    return
                }
                
                self.emailTextField.text = nil
                self.passwordTextField.text = nil
                self.view.endEditing(true)
                
                self.goToApp()
                
                
                
            })
            
            
        }
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        if emailTextField.text != "" {
            
            resetUserPassword(email: emailTextField.text!)
            
        } else {
            
            KRProgressHUD.showError(withMessage: "Email is Empty!")
        }
    }
    

    //MARK: Go to app
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
    }
    


}
