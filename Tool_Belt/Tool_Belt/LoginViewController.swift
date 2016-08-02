//
//  LoginViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 7/26/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let backendless = Backendless.sharedInstance()
    
    var email: String?
    var password: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: IBActions
    
    @IBAction func loginBarButtonPressed(sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            self.email = emailTextField.text
            self.password = passwordTextField.text
            
            // login user
            loginUser(email!, password: password!)
            
        } else {
            // show an error to user
            
            ProgressHUD.showError("All fields are required to login")
        }
    }
    
    func loginUser(email: String, password: String) {
        
        backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
            
            self.passwordTextField.text = ""
            self.emailTextField.text = ""
            
            print("user logged in")
            
//            here segue to UITabBarController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
            vc.selectedIndex = 1
            
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }) { (fault : Fault!) -> Void in
            print("Failed to login user: \(fault)")
        }
        
    }

}
