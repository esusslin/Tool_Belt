//
//  ChooseUserViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/3/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ChooseUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var users: [BackendlessUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("wtf")
        return users.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chooseCell", forIndexPath: indexPath)
        
        let user = users[indexPath.row]
//        print("wtf!")
        
        cell.textLabel?.text = user.email
        
        return cell
        
        
    }
    
    

    

    //MARK: Action:
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: load backendless users
    
    func loadUsers() {
        
        let whereClause = "objectId != '\(currentUser.objectId)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) in
            
            
            self.users = users.data as! [BackendlessUser]
            
//            print("hell0")
            
            
            self.tableView.reloadData()
            
            for user in users.data {
                let u = user as! BackendlessUser
                print(u.firstName)
            }
            
        }) { (fault : Fault!) in
                print("Error retrieving users: \(fault)")
        }
        
    }

}
