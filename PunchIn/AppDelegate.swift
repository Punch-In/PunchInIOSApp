//
//  AppDelegate.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/14/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import Parse

// Command line to start simulator:  open -n /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        ParseDB.initialize()
        
        // add notification handler for user log in & log out events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoggedIn", name: ParseDB.UserLoggedInNotificatioName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoggedOut", name: ParseDB.UserLoggedOutNotificationName, object:nil)
        
        setupGlobalUI()
    
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
    
    func setupGlobalUI() {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()  // Back buttons and such
        UINavigationBar.appearance().barTintColor = ThemeManager.theme().primaryDarkBlueColor() // Bar's background color
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]  // Title's text color
        //UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
    }
    
    func printLocation(){
        LocationProvider.location { (location, error) -> Void in
            if error == nil {
                // have an address
                print("address = \(location!.address)")
            }else if error!.domain != LocationProvider.errorDomain {
                // have coordinates, but no address
                print("coordinates but no address \(error)")
            }else{
                // no location error
                print("no location available! \(error)")
            }
        }
    }
    
    func userLoggedIn() {
        let vc = self.mainStoryboard.instantiateViewControllerWithIdentifier(CoursesListViewController.storyboardName) as! CoursesListViewController
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
        LocationProvider.stopUpdatingLocation()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        LocationProvider.stopUpdatingLocation()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        LocationProvider.startUpdatingLocation()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LocationProvider.stopUpdatingLocation()
    }


}

