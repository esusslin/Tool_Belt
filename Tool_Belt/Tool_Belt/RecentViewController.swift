//
//  RecentViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit


class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var recents: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return recents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            as! RecentTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell.bindData(recent)
        
         return cell
        
    }
    

    
    // MARK: - IBActions
    
    @IBAction func startNewChatBarButtonItemPressed(sender: AnyObject) {
        performSegueWithIdentifier("chatToChooseVC", sender: self)
    }


    
    
    //MARK: Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chatToChooseVC" {
        let vc = segue.destinationViewController as! ChooseUserViewController
        }
    }

  

}
