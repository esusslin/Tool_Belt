//
//  ToolDetailViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox

class ToolDetailViewController: UIViewController {
    
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var toolTitle: UILabel!
    @IBOutlet weak var toolMake: UILabel!
    @IBOutlet weak var toolDescription: UILabel!
    

    @IBOutlet weak var mapView: MGLMapView!
    var toolId: String?
    var ownerId: String?
    var tool: Tool?
    var owner: BackendlessUser?
    
    var annotations: [ToolAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style:.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        toolImageView.layer.cornerRadius = 8.0
        toolImageView.layer.masksToBounds = true
        
        
        
        getTool(self.toolId!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func getTool(toolId: String?) {
        print("hello")
        
        
        let whereClause = "objectId = '\(toolId!)'"
        let dataQuery = BackendlessDataQuery()
        
        dataQuery.whereClause = whereClause
        var error: Fault?
        
        
        let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
        
        if error == nil {
            print("Contacts have been found: \(tools.data)")
            if let tool = tools.data.first as? Tool {
                print("********")
                print(tool.title)
                print("********")
                self.tool = tool
                print("********")
            }

        }
        else {
            print("Server reported an error: \(error)")
        }
        getOwner(self.ownerId!)
        updateUI()
    }
    
    func getOwner(ownerId: String?) {
        print("hello")
        
        print(ownerId)
        let whereClause = "objectId = '\(ownerId!)'"
        let dataQuery = BackendlessDataQuery()
        
        dataQuery.whereClause = whereClause
        var error: Fault?
        
        
        let owners = Backendless.sharedInstance().data.of(BackendlessUser.ofClass()).find(dataQuery, fault: &error)
        
        if error == nil {
            print("Contacts have been found: \(owners.data)")
            if let owner  = owners.data.first as? BackendlessUser {
              
                self.owner = owner
              
            }
            
        }
        else {
            print("Server reported an error: \(error)")
        }
        
    }
    
    func updateUI() {

        self.toolTitle.text = self.tool!.title!
        self.toolMake.text = self.tool!.make!
        //        avatarSwitch.setOn(avatarSwitchStatus, animated: false)
        
        
        print("hello")
        getImageFromURL(tool!.picture! as! String, result: { (image) -> Void in
            self.toolImageView.image = image
        })
        
        addAnnotation()
        
    }
    

    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
        func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
            
            let index = (self.annotations as NSArray).indexOfObject(annotation)
            
            let leftView = UIImageView(image: annotations[index].toolPic)
            leftView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            leftView.layer.cornerRadius = 8.0
            leftView.layer.masksToBounds = true
            
            return leftView
            
            
        }
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .DetailDisclosure)
    }
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        
        UIAlertView(title: annotation.title!!, message: "A lovely (if touristy) place.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
    }
    

    func addAnnotation() {
        
        let latitude = (self.tool!.location?.latitude)!
        let longitude = (self.tool!.location?.longitude)!
        
        let owner = (self.owner)!
        
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! Double, longitude as! Double)
        
        let marker = ToolAnnotation()
        marker.coordinate = location
        marker.title = owner.name!
        
        if let avatarURL = owner.getProperty("Avatar") {
            print("********")
            print(avatarURL)
            print("********")
            getImageFromURL(avatarURL as! String, result: { (image) in
                marker.toolPic = image
            })
            
            self.annotations.append(marker)
            
            
            self.mapView.addAnnotations(self.annotations)
            
            // Center the map on the annotation.
            mapView.setCenterCoordinate(marker.coordinate, zoomLevel: 12, animated: false)
        }
    }
}
