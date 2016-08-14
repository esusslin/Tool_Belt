//
//  AppDelegate.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 7/23/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D?
    
    let APP_ID = "BB66E657-7792-16CB-FF33-0BAA043F6F00"
    let SECRET_KEY = "81A8E053-495E-29CC-FFF5-C7C680E24200"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        //facebook intialized:
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        return true
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
        
        locationManagerStart()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        locationManagerStop()
    }
    
    //MARK: LocationManager functions
    
    func locationManagerStart() {
        if locationManager == nil {
            print("init locationManager")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        }
        
        print("have location manager")
        locationManager!.startUpdatingLocation()
        
    }
    
    func locationManagerStop() {
        locationManager!.stopUpdatingLocation()
    }
    
    // MARK: CLLocation Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        coordinate = newLocation.coordinate
    }

    
    //MARK: FacebookLogin
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let result = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication:sourceApplication, annotation: annotation)
        
        if result {
            let token = FBSDKAccessToken.currentAccessToken()
            
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email"], tokenString: token.tokenString, version: nil, HTTPMethod: "GET")
            
            request.startWithCompletionHandler({ (connection, result, error : NSError!) in
                
                if error == nil {
                    let facebookId = result["id"]! as! String
                    
                    let avatarUrl = "https://graph.facebook.com/\(facebookId)/picture??type=nomral"
                    
                    //update backendless user with facebook avatar link
                    updateBackendlessUser(facebookId, avatarUrl: avatarUrl)
                    
                } else {
                    print("Facebook request error \(error)")
                }
            })
            
            let fieldsMapping = ["id" : "facebookId", "name" : "name", "email" : "email"]
            
            backendless.userService.loginWithFacebookSDK(token, fieldsMapping: fieldsMapping)
        }
        
        return result
    }


}

