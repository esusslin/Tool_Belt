//
//  MyToolBeltTableViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/15/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class MyToolBeltTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let backendless = Backendless.sharedInstance()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var myTools: [Tool]! = []
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

           loadMyTools()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(myTools.count)
        return myTools.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Tool Cell", forIndexPath: indexPath)
            as! MyToolBeltTableViewCell
        
        let tool = myTools[indexPath.row]
        
         cell.bindData(self.myTools[indexPath.row])
        
        return cell
        
    }
    
    //MARK: UITableviewDelegate functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let tool = myTools[indexPath.row]
        
        
        performSegueWithIdentifier("toolBeltToShow", sender: indexPath)
    }
    
    @IBAction func addToolButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("toolBeltToNewToolForm", sender: self)
    }
    
    //MARK: Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toolBeltToShow" {
            let indexPath = sender as! NSIndexPath
            let toolVC = segue.destinationViewController as! ToolShowTableViewController
            
            
            let tool = myTools[indexPath.row]
            
            toolVC.tool = tool
            
            
        }
        
    }
    
    func loadMyTools() {
        
        
        let whereClause = "ownerId = '\(backendless.userService.currentUser.objectId)'"
        let dataQuery = BackendlessDataQuery()
        
        dataQuery.whereClause = whereClause
        var error: Fault?
        
        let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
        
        if error == nil {
            print("Contacts have been found: \(tools.data)")
            
            self.myTools.appendContentsOf(tools.data as! [Tool]!)

            for tool in tools.data as! [Tool] {
                print(tool.title)
                
            }
            
                self.tableView.reloadData()
          
            
        }
        else {
            print("Server reported an error: \(error)")
        }

        
    }

}
