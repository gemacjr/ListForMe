//
//  AppDelegate.swift
//  Listin
//
//  Created by Ed McCormic on 7/12/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var firstLoad: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.361286521, green: 0.729783535, blue: 0.368743211, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.361286521, green: 0.729783535, blue: 0.368743211, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        loadUserDefaults()
        
        Firebase.Auth.auth().addStateDidChangeListener { (auth, user) in
            
            
            if user != nil {
                
                if userDefaults.object(forKey: kCURRENTUSER) != nil {
                    self.goToApp()
                }
            }
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func loadUserDefaults() {
        
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set("$", forKey: kCURRENCY)
            userDefaults.synchronize()
        }
    }
    
    //MARK: Go to app
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
    }


}

