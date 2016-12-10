//
//  HomeViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 9/13/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class HomeViewController: UIViewController, MGLMapViewDelegate, UISearchBarDelegate {
    
    let backendless = Backendless.sharedInstance()
    
    let locationManager = CLLocationManager()

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tools = [Tool]()
    var users = [BackendlessUser]()
    
    var annotations: [ToolAnnotation] = []
    
    var avatarImagesDictionary: NSMutableDictionary?
    var avatarDictionary: NSMutableDictionary?
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var firstFindButton: UIButton!
    @IBOutlet weak var firstSearchBar: UISearchBar!
    @IBOutlet weak var secondFindButton: UIButton!
    @IBOutlet weak var secondSearchBar: UISearchBar!
    
    var mask: CALayer!
    var animation: CABasicAnimation!
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.appDelegate.coordinate?.longitude)
        
        firstFindButton.layer.cornerRadius = 8.0
        firstFindButton.layer.masksToBounds = true
        firstSearchBar.layer.cornerRadius = 8.0
        firstSearchBar.layer.masksToBounds = true


        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.tintColor = UIColor.darkGrayColor()
  
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: (self.appDelegate.coordinate?.latitude)!, longitude: (self.appDelegate.coordinate?.longitude)!), zoomLevel: 12, animated: false)
   
        // Set the map view‘s delegate property
        mapView.delegate = self
    }
    
    @IBAction func listSearchButtonPressed(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ToolSearchTableView") as! ToolSearchTableViewController
        print(self.tools)
        vc.tools = self.tools
        
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("pisa")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "rsz_1job_filled_100-1")!
            

            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pisa")
        }
        
        return annotationImage
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
            print(self.annotations.count)
            print(self.annotations[0].toolPic)

            let leftView = UIImageView(image: annotations[index].toolPic as UIImage!)
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

        let index = (self.annotations as NSArray).indexOfObject(annotation)

        print(annotations[index].toolId)


        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ToolDetailShow") as! ToolDetailViewController
        vc.ownerId = annotations[index].ownerId
        vc.toolId = annotations[index].toolId
        
        self.navigationController!.pushViewController(vc, animated: true)
        

    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation)")
        
        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
    }

    

    @IBAction func firstFindButtonPressed(sender: AnyObject) {
        
        
        self.findTools(self.firstSearchBar.text)
        animateLaunch(UIImage(named: "wrench-2")!)
    }
    
    @IBAction func secondFindButtonPressed(sender: AnyObject) {
        self.tools.removeAll()
        for _annotation in annotations {
            if let annotation = _annotation as? ToolAnnotation {
                self.mapView.removeAnnotation(annotation)
            }
        }
        self.annotations.removeAll()
       
        self.findTools(self.secondSearchBar.text)
        
    }
    
    
    
    func findTools(toolString: String?) {
        
        let whereClause = "title LIKE '\((toolString)!)' AND distance(\((self.appDelegate.coordinate?.latitude)!), \((self.appDelegate.coordinate?.longitude)!), location.latitude, location.longitude ) < mi(6)"
        
        print(whereClause)
        let dataQuery = BackendlessDataQuery()
        let queryOptions = QueryOptions()
        queryOptions.related = ["tools"]
        
        print((self.appDelegate.coordinate?.latitude)!)
        print((self.appDelegate.coordinate?.longitude)!)
        
        dataQuery.whereClause = whereClause
        
        var error: Fault?
        let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
        
        if error == nil {
            print("Contacts have been found: \(tools.data)")
        }
        else {
            print("Server reported an error: \(error)")
        }
        
        let currentPage = tools.getCurrentPage()
        
        for tool in currentPage as! [Tool] {
            
            
            
            let latitude = (tool.location?.latitude)!
            let longitude = (tool.location?.longitude)!
            let toolId = (tool.objectId)!
            let ownerId = (tool.ownerId)!
            
            var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! Double, longitude as! Double)
            
            let toolName = (tool.title)!
            let toolDescription = (tool.toolDescription)!
            
            let marker = ToolAnnotation()
            marker.coordinate = location
            
            getImageFromURL(tool.picture! as! String, result: { (image) -> Void in
                marker.toolPic = image
                tool.toolPic = image
                self.tools.append(tool)
            })
            //            marker.accessibilityValue = toolId
            
            marker.title = toolName
            marker.subtitle = toolDescription
            marker.toolId = toolId
            marker.ownerId = ownerId
            
            self.annotations.append(marker)
            
            
            self.mapView.addAnnotations(self.annotations)

        }
        
        
    }

    
    func animateLaunch(image: UIImage) {
        
//        self.view.backgroundColor = bgColor
        
        // Create and apply mask
        
        mask = CALayer()
        mask.contents = image.CGImage
        mask.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: mainView.frame.width / 2.0, y: mainView.frame.height / 2.0)
        mainView.layer.mask = mask
        
        animateDecreaseSize()
        
    }
    
    func animateDecreaseSize() {
    
        let decreaseSize = CABasicAnimation(keyPath: "bounds")
        decreaseSize.delegate = self
        decreaseSize.duration = 1.0
        decreaseSize.fromValue = NSValue(CGRect: mask!.bounds)
        decreaseSize.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 15, height: 15))
        
        decreaseSize.fillMode = kCAFillModeForwards
        decreaseSize.removedOnCompletion = false
        
        mask.addAnimation(decreaseSize, forKey: "bounds")
        
    
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animateIncreaseSize()
    }
    
    func animateIncreaseSize() {
        
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 2.0
        animation.fromValue = NSValue(CGRect: mask!.bounds)
        animation.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 4000, height: 4000))
        
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        mask.addAnimation(animation, forKey: "bounds")
        
        // Fade out overlay
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            self.overlay.alpha = 0
            
            
    })

   }
   
}

