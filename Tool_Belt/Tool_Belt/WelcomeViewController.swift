//
//  WelcomeViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 7/26/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    let backendless = Backendless.sharedInstance()
    var currentUser: BackendlessUser?
    
    override func viewWillAppear(animated: Bool) {
        backendless.userService.setStayLoggedIn(true)
        
        currentUser = backendless.userService.currentUser
        
        if currentUser != nil {
//            print(currentUser?.email)
            dispatch_async(dispatch_get_main_queue()) {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar") as! TabBarController
                vc.selectedIndex = 0
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.readPermissions = ["public_profile", "email"]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
