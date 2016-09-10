//
//  NewTool2ViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/10/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI


class NewTool2ViewController: UIViewController {
    
    @IBOutlet weak var toolTitle: UITextField!
    @IBOutlet weak var toolMake: UITextField!
    @IBOutlet weak var toolDescription: UITextField!
    
    @IBOutlet weak var toolParticulars: UIButton!
    
    let info = UILabel()
    
    var toolAddress: String?
    
    var geocoder: CLGeocoder = CLGeocoder()
    
    var tooLong = Double()
    var tooLat = Double()
    
    var toolLocation: GeoPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolParticulars.layer.cornerRadius = 8.0
        toolParticulars.layer.masksToBounds = true
        
        info.frame = CGRect(x: 0.0, y: toolParticulars.center.y + 60.0,
                            width: view.frame.size.width, height: 30)
        info.backgroundColor = UIColor.clearColor()
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment = .Center
        info.textColor = UIColor.whiteColor()
        info.text = "Enter the address where this tool will be available"
        view.insertSubview(info, belowSubview: toolParticulars)
        
        getLocation()
                
        // Do any additional setup after loading the view.
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
    
    func getLocation() {
        
        geocoder.geocodeAddressString(toolAddress!) { (placemarks, error) -> Void in
            
            if let firstPlacemark = placemarks?[0] {
            
                                self.tooLat = firstPlacemark.location!.coordinate.latitude
            
                                self.tooLong = firstPlacemark.location!.coordinate.longitude
            
                                self.toolLocation = GeoPoint.geoPoint(GEO_POINT(latitude: self.tooLat, longitude: self.tooLong)) as? GeoPoint
            }

        }

    }


    
    @IBAction func toolParticularsButtonPressed(sender: AnyObject) {
        
        let newTool = Tool()
        
        newTool.title = toolTitle.text
        newTool.make = toolMake.text
        newTool.toolDescription = toolDescription.text
        newTool.location = toolLocation
        
        backendless.persistenceService.of(Tool.ofClass()).save(newTool,
                                                               response: { ( d : AnyObject!) -> () in
                                                                print("ASYNC: Tool has been saved. Location object ID - \((d as! Tool).location!.objectId)")
                                                                
                                                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ToolShow") as! ToolViewController
                                                                    vc.tool = d as! Tool
                                                                
                                                                self.presentViewController(vc, animated: true, completion: nil)

                                                                
            },
                                                               
                                                               error: { ( fault : Fault!) -> () in
                                                                print("Server reported an error: \(fault)")
        })
    }
    
    //MARK: Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newTool2ToolShowSeg" {
            
            let newTool2VC = segue.destinationViewController as! NewTool2ViewController
            
            print(self.toolAddress)
            print(toolAddress)
            
            newTool2VC.toolAddress = toolAddress!
            
        }
        
    }

}
