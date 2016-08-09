//
//  RecentViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/1/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit


class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChooseUserDelegate {
    
    
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
    
    //MARK: UITableviewDelegate functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        let recent = recents[indexPath.row]
        
//        RestartRecentChat(recent)
        
        performSegueWithIdentifier("recentToChatSeg", sender: indexPath)
    }
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let recent = recents[indexPath.row]
        
        // remove recent from the array
        recents.removeAtIndex(indexPath.row)
        
        // delete recent from firebase
        
//        DeleteRecentItem(recent)
        
        tableView.reloadData()
        
    }
    

    
    // MARK: - IBActions
    
    @IBAction func startNewChatBarButtonItemPressed(sender: AnyObject) {
        performSegueWithIdentifier("chatToChooseVC", sender: self)
    }


    
    
    //MARK: Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chatToChooseVC" {
        let vc = segue.destinationViewController as! ChooseUserViewController
        vc.delegate = self
        }
        
        if segue.identifier == "recentToChatSeg" {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destinationViewController as! ChatViewController
            
            let recent = recents[indexPath.row]
            
//            set ChatVC recent to our recent
        
        }
        
    }
    
    //MARK: ChooseUserDelegate
    
    func createChatroom(withUser: BackendlessUser) {
        
        let chatVC = ChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVC, animated: true)
    }


  

}
