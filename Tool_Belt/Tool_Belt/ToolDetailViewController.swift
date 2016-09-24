//
//  ToolDetailViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox


class ToolDetailViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var toolTitle: UILabel!
    @IBOutlet weak var toolMake: UILabel!
    @IBOutlet weak var toolDescription: UILabel!
    

    @IBOutlet weak var mapView: MGLMapView!
    
    var delegate: ChooseUserDelegate!
    
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
        mapView.delegate = self
        mapView.selectAnnotation(mapView.annotations![0], animated: true)
        
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
        // Always allow callouts to popup when annotations are tapped
        return true
    }
    
    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        // Only show callouts for `Hello world!` annotation
        if annotation.respondsToSelector(Selector("title")) && annotation.title! == "Hello world!" {
            // Instantiate and return our custom callout view
            
            return CustomCalloutView(representedObject: annotation)
        }
        return nil
    }
    
    
    func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        
        let index = (self.annotations as NSArray).indexOfObject(annotation)
        
        let leftView = UIImageView(image: annotations[index].toolPic)
        leftView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        .frame.size.width/2
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
    
        let optionMenu = UIAlertController(title: nil, message: "Contact \(annotation.title!!) about this \(self.tool!.title!)?", preferredStyle: .ActionSheet)
        
        let contactOwnerAction = UIAlertAction(title: "Yes", style: .Destructive) { (alert: UIAlertAction!) -> Void in
            self.contactOwner()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            print("cancelled")
        }
        
        optionMenu.addAction(contactOwnerAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
//                UIAlertView(title: self.tool!.title!, message: "Contact \(annotation.title!!) about this \(self.tool!.title!)?", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation)")
        
        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
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
//            self.mapView.annotations.calloutAccessoryControlTapped(self.annotations[0], animated: true)
        }
    }
    
   func contactOwner() {
    print(self.owner!)
    print(currentUser!)
    
    
    let chatVC = ChatViewController()
    chatVC.hidesBottomBarWhenPushed = true
    
    navigationController?.pushViewController(chatVC, animated: true)
    
    chatVC.withUser = owner
    chatVC.chatRoomId = startChat(currentUser, user2: owner!)
    }
}
