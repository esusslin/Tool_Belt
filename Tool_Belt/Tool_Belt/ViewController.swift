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
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        findContactByName()
//        registerUser()
        
    }
    
//    func registerUser() {
//        Types.tryblock({ () -> Void in
//            let user : BackendlessUser = BackendlessUser()
//            user.email = "esusslin@fuckyou.com"
//            user.password = "password"
//            
//            let hammer = Tool()
//            hammer.ownerId = user.objectId
//            hammer.make = "binford"
//            hammer.title = "hammer"
//            hammer.toolDescription = "solid damn hammer"
//            
//            user.setProperty("tools", object: hammer)
//            
//            self.backendless.userService.registering(user)
//            print("user registered");
//        },
//                       catchblock: { (exception) -> Void in
//                        print("Server reported an error: \(exception as! Fault)")
//    })
//    }
  
//    func findContactByName() {
//        
//        let whereClause = "title = 'hammer'"
//        let dataQuery = BackendlessDataQuery()
//        dataQuery.whereClause = whereClause
//        
//        var error: Fault?
//        let bc = backendless.data.of(Users.ofClass()).find(dataQuery, fault: &error)
//        if error == nil {
//            print("Contacts have been found: \(bc.data)")
//        }
//        else {
//            print("Server reported an error: \(error)")
//        }
//    }

}

