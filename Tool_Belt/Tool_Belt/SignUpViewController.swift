//
//  SignUpViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 7/26/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
//    @IBOutlet weak var nameTextField: UITextField!
//
//    @IBOutlet weak var emailTextField: UITextField!
//    
//    @IBOutlet weak var passwordTextField: UITextField!
//    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var email: String?
    var name: String?
    var password: String?
    var avatarImage: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUser = BackendlessUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: sign up button
    

    @IBAction func signUpButtonPressed(sender: UIButton) {
        
                if emailTextField.text != "" && nameTextField.text != "" {
        
                  ProgressHUD.show("Registering...")
        
                    email = emailTextField.text
                    name = nameTextField.text
                    password = passwordTextField.text
        
                    register(self.email!, name: self.name!, password: self.password!, avatarImage: self.avatarImage)
                } else {
                    // warning to user - email, password and username required
                    ProgressHUD.showError("All fields are required to register")
                }
        
    }


//    }
    
    //MARK: Backendl!ess user registration
    
    func register(email: String, name: String, password: String, avatarImage: UIImage?) {
        
        if avatarImage == nil {
            newUser!.setProperty("Avatar", object: "")
        }
        
        newUser!.email = email
        newUser!.name = name
        newUser!.password = password
        
        backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) ->
            Void in
            
            ProgressHUD.dismiss()
            
            //login new user
            self.loginUser(email, password: password)
            
            self.nameTextField.text = ""
            self.passwordTextField.text = ""
            self.emailTextField.text = ""
            
        }) { (fault : Fault!) -> Void in
            print("Server reported an error, new user registration failed: \(fault)")
            ProgressHUD.showError("Server reported an error, new user registration failed")
        }
        
    }
    
    func loginUser(email: String, password: String) {
        
        backendless.userService.login(email, password: password, response: { (user : BackendlessUser!) -> Void in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
            vc.selectedIndex = 1
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }) { (fault : Fault!) in
            print("Server reported an error: \(fault)")
            
        }
    }


}
