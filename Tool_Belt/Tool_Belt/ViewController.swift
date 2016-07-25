//
//  ViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 7/23/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var backendless = Backendless.sharedInstance()
//    var currentUser = BackendlessUser?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerUser()
    }
    
    func registerUser() {
        
//        Types.tryblock({ () -> Void in
//            let user : BackendlessUser = BackendlessUser()
//            user.email = "emmet@gmail.com"
//            user.password = "password"
//            
////            let hammer = Tool()
////            hammer.title = "hammer"
////            hammer.make = "binford"
////            hammer.toolDescription = "solid fucking hammer"
////            hammer.ownerId = user.objectId
////            
////            let drill = Tool()
////            drill.title = "drill"
////            drill.make = "binford"
////            drill.toolDescription = "solid fucking drill"
////            drill.ownerId = user.objectId
//  
//            
//            self.backendless.userService.registering(user)
//            print(user.objectId)
//            var currentUser = self.backendless.userService.currentUser
//            print("user registered");
//        },
//                catchblock: { (exception) -> Void in
//                        print("Server reported an error: \(exception as! Fault)")
//                    
//                    
//        })
        
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        
        var currentUser = backendless.userService.currentUser
//        print(currentUser.objectId)
        
        saveNewTool()
    }

    func saveNewTool() {
        
        let hammer = Tool()
        hammer.title = "hammer"
        hammer.make = "binford"
        hammer.toolDescription = "solid fucking hammer"
        hammer.ownerId = "BBD41923-F796-A7F9-FF93-2C32B1159800"
        
        let dataStore = backendless.data.of(Tool.ofClass())
        
        // save object synchronously
        var error: Fault?
        let result = dataStore.save(hammer, fault: &error) as? Tool
        if error == nil {
            print("Contact has been saved: \(result!.objectId)")
        }
        else {
            print("Server reported an error: \(error)")
        }
        
    }

}

