//
//  ToolSearchTableViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/24/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ToolSearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tools = [Tool]()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        loadTools()
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

        return tools.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Tool Search Cell", forIndexPath: indexPath)
            as! ToolSearchTableViewCell
        
        let tool = tools[indexPath.row]
        
        cell.bindData(self.tools[indexPath.row])
        
        return cell
        
    }
    
    //MARK: UITableviewDelegate functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ToolDetailShow") as! ToolDetailViewController
        let tool = tools[indexPath.row]
        vc.toolId = tool.objectId
        vc.ownerId = tool.ownerId
        
        self.navigationController!.pushViewController(vc, animated: true)
    }

    @IBAction func findButtonPressed(sender: AnyObject) {
        self.tools.removeAll()
        self.findTools(self.searchBar.text)
        
    }
    
    func findTools(toolString: String?) {
        
        let whereClause = "title LIKE '\((toolString)!)' AND distance('\((self.appDelegate.coordinate?.latitude)!)', '\((self.appDelegate.coordinate?.longitude)!)', location.latitude, location.longitude ) < mi(6)"
        let dataQuery = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.related = ["tools"]
        
        dataQuery.whereClause = whereClause
        
        var error: Fault?
        let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
        
        if error == nil {
            print("Contacts have been found: \(tools.data)")
            
            
            
            for tool in tools.data as! [Tool] {
                print(tool.title)
                
                getImageFromURL(tool.picture! as! String, result: { (image) -> Void in
                    tool.toolPic = image
                    
                    print(tool.toolPic)
                    
                    self.tools.append(tool)
                  self.tableView.reloadData()
                })
                
            }
            
//            self.tableView.reloadData()
            
            
        }
        else {
            print("Server reported an error: \(error)")
        }

    }
    
    func loadTools() {

        self.tableView.reloadData()
    }
    
}
