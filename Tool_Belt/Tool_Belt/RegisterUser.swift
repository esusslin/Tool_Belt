//
//  RegisterUser.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import Foundation

func updateBackendlessUser(facebookId: String, avatarUrl: String) {
    
    var backendless = Backendless.sharedInstance()
    
    let whereClause = "facebookId = '\(facebookId)'"
    
    let dataQuery = BackendlessDataQuery()
    dataQuery.whereClause = whereClause
    
    let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
    dataStore.find(dataQuery, response: { (users : BackendlessCollection!) in
        
        let user = users.data.first as! BackendlessUser
        
        let properties = ["Avatar" : avatarUrl]
        
        user.updateProperties(properties)
        
        backendless.userService.update(user)
        
    }) { (fault: Fault!) in
        print("server error : \(fault)")
    }
}