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

class NewToolViewController: UIViewController, CLLocationManagerDelegate {
    
    var backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var makeTextField: UITextField!

    @IBOutlet weak var toolDescriptionTextField: UITextField!
    
    @IBOutlet weak var toolAddressTextField: UITextField!
    
  
    var geocoder:CLGeocoder = CLGeocoder()
    
//    var newTool = Tool()
//    
//    var toolTitle: String?
//    var toolMake: String?
//    var toolDescription: String?
    var tooLong = Double()
    var tooLat = Double()
    var toolAddress: String?
//    var toolLocation: GeoPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //

    @IBAction func listToolButtonPressed(sender: UIButton) {
        
        
        if titleTextField.text != "" && makeTextField.text != "" && toolDescriptionTextField.text != "" && toolAddressTextField.text != "" {
            
            toolAddress = toolAddressTextField.text
            
            print("hello")
            
            
            
            geocoder.geocodeAddressString(toolAddress!) { (placemarks, error) -> Void in
                if let firstPlacemark = placemarks?[0] {
                     print("hello1")
                    self.tooLat  = firstPlacemark.location!.coordinate.latitude
//                     let tooLat
                    self.tooLong = firstPlacemark.location!.coordinate.longitude
                    
                }
            }
            
            let newTool = Tool()
            
            newTool.title = titleTextField.text
            newTool.make = makeTextField.text
            newTool.toolDescription = toolDescriptionTextField.text
            newTool.location = GeoPoint.geoPoint(GEO_POINT(latitude: tooLat, longitude: tooLong)) as? GeoPoint
            


//            ProgressHUD.show("Registering new tool...")
            
            backendless.persistenceService.of(Tool.ofClass()).save(newTool,
                                                                     response: { ( d : AnyObject!) -> () in
                                                                        print("ASYNC: Tool has been saved. Location object ID - \((d as! Tool).location!.objectId)")
                },
                                                                     
                                                                     error: { ( fault : Fault!) -> () in
                                                                        print("Server reported an error: \(fault)")
            })
            
        } else {
            // show an error to user
            
            ProgressHUD.showError("All fields are required to login")
        }
        
    }
   

}
