//
//  ToolPicViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/18/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ToolPicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    var backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var toolPic: UIImageView!
    
    let info = UILabel()
    
    var tool: Tool?
    
    var tool_title: String?
    var tool_make: String?
    var tool_description: String?
    var tool_location: GeoPoint?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        info.frame = CGRect(x: 0.0, y: toolPic.center.y + 60.0,
                            width: view.frame.size.width, height: 30)
        info.backgroundColor = UIColor.clearColor()
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .Center
        info.textColor = UIColor.whiteColor()
        info.text = "Please provide a picture of your listed tool to enhance our user experience"
        view.insertSubview(info, belowSubview: toolPic)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toolPicButtonPressed(sender: AnyObject) {
        setToolPhoto()
    }
    
    func setToolPhoto() {
        
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
            
            newtool.title = self.tool_title!
            newtool.make = self.tool_make!
            newtool.ownerId = currentUser.objectId!
          
            newtool.location = self.tool_location!
            newtool.toolDescription = self.tool_description!
            newtool.picture = imageLink!
            newtool.available = true
            
            let updatedTool = dataStore.save(newtool, fault: &error) as? Tool
            if error == nil {
                print("Contact has been updated: \(updatedTool!.objectId)")
//                
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ToolShowView") as! ToolShowTableViewController
                self.tool = updatedTool!
                
                self.performSegueWithIdentifier("newTooldone!", sender: self)
                
//                self.presentViewController(vc, animated: true, completion: nil)
            }
            else {
                print("Server reported an error (2): \(error)")
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
//        print(updatedTool!)
        
        
    }
    
    //MARK: Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        ProgressHUD.dismiss()
        
        if segue.identifier == "newTooldone!" {
            
            let newTool2VC = segue.destinationViewController as! NewToolShowTableViewController
//            let newTool2VC = segue.destinationViewController as! NewToolShowTableViewController
//            let newTool2VC = nav.topViewController as! NewToolShowTableViewController

            
            
            newTool2VC.tool = self.tool
            
            
            
        }
    }
  


}
