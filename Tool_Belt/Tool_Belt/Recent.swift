//
//  Recent.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/2/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let firebase = FIRDatabase.database().referenceFromURL("https://toolbelt-542d9.firebaseio.com/")
let backendless = Backendless.sharedInstance()
let currentUser = backendless.userService.currentUser

//MARK: helper functions

private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
