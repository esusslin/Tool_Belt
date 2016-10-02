//
//  NewToolShowTableViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/18/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class NewToolShowTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var toolImage: UIImageView!
    
    @IBOutlet weak var toolTitleLabel: UILabel!
    
    @IBOutlet weak var toolMakeLabel: UILabel!
    
    @IBOutlet weak var availableCell: UITableViewCell!
    
    @IBOutlet weak var availableSwitch: UISwitch!
    
    @IBOutlet weak var editToolInfoCell: UITableViewCell!

    @IBOutlet weak var profileCell: UITableViewCell!
    
    var tool: Tool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = headerView
        
        toolImage.layer.cornerRadius = 8.0
        toolImage.layer.masksToBounds = true
        
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Actions
    
    @IBAction func didClickToolImage(sender: AnyObject) {
        
        changePhoto()
    }
    
    @IBAction func availableSwitched(sender: UISwitch) {
        
                if availableSwitch.on {
                    self.tool?.available = true
                    print(self.tool?.available)
                } else {
                    self.tool?.available = false
                    print(self.tool?.available)
                }
        
    }

    
    @IBAction func profileButtonPressed(sender: AnyObject) {
        
        backtoProfile()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return 2 }
        if section == 1 { return 1 }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ((indexPath.section == 0) && (indexPath.row == 0)) { return availableCell }
        if ((indexPath.section == 0) && (indexPath.row == 1)) { return editToolInfoCell }
        if ((indexPath.section == 1) && (indexPath.row == 0)) { return profileCell }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        } else {
            return 25.0
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    //MARK: tableview delegate functions
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
//            print("hello")
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
//            print("hello")
//            vc.selectedIndex = 0
//            
//            self.presentViewController(vc, animated: true, completion: nil)
            backtoProfile()
        }
    }
    
    //MARK: Change pic
    
    func changePhoto() {
        print("2")
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            
            camera.PresentPhotoCamera(self, canEdit: true)
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoLibrary(self, canEdit: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            print("Cancel")
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    //MARK: UIImagePickerControllerDelegate functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let dataStore = Backendless.sharedInstance().data.of(Tool.ofClass())
        var error: Fault?
        
        let newtool = Tool()
        
        
        uploadAvatar(image) { (imageLink) -> Void in
            
            newtool.title = self.tool!.title!
            newtool.make = self.tool!.make!
            newtool.ownerId = self.tool!.ownerId!
            newtool.location = self.tool!.location!
            newtool.toolDescription = self.tool!.toolDescription!
            newtool.picture = imageLink!
            
            let updatedTool = dataStore.save(newtool, fault: &error) as? Tool
            if error == nil {
                print("Contact has been updated: \(updatedTool!.objectId)")
            }
            else {
                print("Server reported an error (2): \(error)")
            }
            
        }
        updateUI()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Update UI
    
    func updateUI() {
        
        
        
        toolTitleLabel.text = self.tool!.title!
        toolMakeLabel.text = self.tool!.make!
        //        avatarSwitch.setOn(avatarSwitchStatus, animated: false)
        
        
        print("hello")
        getImageFromURL(tool!.picture! as! String, result: { (image) -> Void in
            self.toolImage.image = image
        })
        
    }
    
   func backtoProfile() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
    
        vc.selectedIndex = 0
        
    }
    
    
    
}
