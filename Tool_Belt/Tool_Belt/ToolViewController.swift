//
//  ToolViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/10/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class ToolViewController: UIViewController {
    
    let backendless = Backendless.sharedInstance()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tool: Tool?
    
    @IBOutlet weak var toolImageView: UIImageView!
    
    @IBOutlet weak var toolTitle: UILabel!

    @IBOutlet weak var toolMake: UILabel!
    
    
    @IBOutlet weak var toolDescription: UILabel!
    
    @IBOutlet weak var availableSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()

        print(tool!.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteToolButtonPressed(sender: AnyObject) {
        
        print("delete \((tool!.title)!)?")
        
    }
    
    //MARK: Update UI
    
    func updateUI() {
        
        self.toolTitle.text = tool!.title
        self.toolMake.text = tool!.make
        self.toolDescription.text = tool!.toolDescription
        self.toolImageView.image = UIImage(named: "avatarPlaceholder")
        
        //        avatarSwitch.setOn(avatarSwitchStatus, animated: false)
        
//        if let imageLink = tool!.getProperty("Avatar") {
//            getImageFromURL(imageLink as! String, result: { (image) -> Void in
//                self.imageUser.image = image
//            })
//        }
    }

}
