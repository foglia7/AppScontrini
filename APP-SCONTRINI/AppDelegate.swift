//
//  AppDelegate.swift
//  APP-SCONTRINI
//
//  Created by Mhscio on 18/11/2019.
//  Copyright © 2019 Mhscio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
       
        return true

      
    }
    
  


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func transitionToHome(){
        let homeViewController = UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController)
        self.window?.rootViewController = homeViewController
    }



}

