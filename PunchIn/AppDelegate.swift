//
//  AppDelegate.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/14/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        ParseDB.initialize()
        //DataInjector.doIt()
        
        
        // add notification handler for user log in & log out events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoggedIn", name: Constants.Notifications.UserLoggedIn, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoggedOut", name:Constants.Notifications.UserLoggedOut, object:nil)

        // skip login if user is already logged in
        if let user = PFUser.currentUser() {
            // check if session needs to be reauthenticated
            do{
                try PFUser.become(user.sessionToken!)
                print("user \(PFUser.currentUser()!.username) logged in")
                self.userLoggedIn()
            }catch{
                print("need to reauthenticate session \(error)")
            }
        }

        return true
    }
    
    func userLoggedIn() {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier(Constants.Storyboard.CoursesListViewController) as! CoursesListViewController
        let navigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationController
    }
    
    func userLoggedOut() {
        let vc = mainStoryboard.instantiateInitialViewController()
        window?.rootViewController = vc
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

