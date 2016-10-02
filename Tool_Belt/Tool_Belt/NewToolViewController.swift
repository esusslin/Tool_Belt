//
//  NewToolViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/15/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

// A delay function
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class NewToolViewController: UIViewController {
    
    var backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var listAddress: UIButton!
    
    @IBOutlet weak var toolAddressTextField: UITextField!
    
    let info = UILabel()
  
    var geocoder: CLGeocoder = CLGeocoder()
    
    var tooLong = Double()
    var tooLat = Double()
    
    var toolAddress: String?
    var toolLocation: GeoPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listAddress.layer.cornerRadius = 8.0
        listAddress.layer.masksToBounds = true
        
        info.frame = CGRect(x: 0.0, y: listAddress.center.y + 60.0,
                            width: view.frame.size.width, height: 30)
        info.backgroundColor = UIColor.clearColor()
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .Center
        info.textColor = UIColor.whiteColor()
        info.text = "Enter the address where this tool will be available"
        view.insertSubview(info, belowSubview: listAddress)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        toolAddressTextField.layer.position.x -= view.bounds.width
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1.0
        fadeIn.duration = 0.5
        fadeIn.fillMode = kCAFillModeBackwards
        fadeIn.beginTime = CACurrentMediaTime() + 0.5
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.7
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.9
        
        fadeIn.beginTime = CACurrentMediaTime() + 1.1
        
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x + view.frame.size.width
        flyLeft.toValue = info.layer.position.x
        flyLeft.duration = 5.0
        info.layer.addAnimation(flyLeft, forKey: "infoappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    @IBAction func buttonPressed(sender: AnyObject) {
        
         print(currentUser.objectId)
       
    }

    @IBAction func listToolButtonPressed(sender: UIButton) {

        if toolAddressTextField.text != "" {
 
            toolAddress = toolAddressTextField.text

            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewTool2") as! NewTool2ViewController
            print(toolAddress!)
            vc.toolAddress = toolAddress!
            
            self.navigationController!.pushViewController(vc, animated: true)
            
        } else {
            // show an error to user230
            
            ProgressHUD.showError("Please enter an address")
        }
        
    }
    
    

}
