//
//  MapSearchViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/18/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapSearchViewController: UIViewController, UISearchBarDelegate {
    
    let backendless = Backendless.sharedInstance()
    
//    var users: [BackendlessUser] = []
    
    let locationManager = CLLocationManager()

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tools = [Tool]()
    var users = [BackendlessUser]()
    
    var avatarImagesDictionary: NSMutableDictionary?
    var avatarDictionary: NSMutableDictionary?
   

    @IBOutlet weak var searchBar: UISearchBar!
   

    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(self.appDelegate.coordinate?.latitude)
//        print(self.appDelegate.coordinate?.longitude)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//        mapView.showsUserLocation = true
//        mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBitch(sender: UIBarButtonItem) {
        
//                    //MARK: find tools
        
                   let whereClause = "distance('\((self.appDelegate.coordinate?.latitude)!)', '\((self.appDelegate.coordinate?.longitude)!)', location.latitude, location.longitude ) < mi(6)"
                    let dataQuery = BackendlessDataQuery()
                    let queryOptions = QueryOptions()
                    queryOptions.related = ["tools"]
        
                    dataQuery.whereClause = whereClause
        
                    var error: Fault?
                    let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
   
                        if error == nil {
                        print("Contacts have been found: \(tools.data)")
                            }
                            else {
                                print("Server reported an error: \(error)")
                            }
        
                            backendless.persistenceService.of(Tool.ofClass()).find(
                                        dataQuery, response: { ( tools : BackendlessCollection!) -> () in
                
                                        let currentPage = tools.getCurrentPage()

                                        for tool in currentPage as! [Tool] {
                    
                                            let latitude = (tool.location?.latitude)!
                                            let longitude = (tool.location?.longitude)!
                    
                                            var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! Double, longitude as! Double)
                    
                    

                                            let toolName = (tool.title)!
                                           
                                            let toolDescription = (tool.toolDescription)!
                                      
                                            

                                            let thiswhereClause = "objectId != '\((tool.ownerId)!)'"

                                            //MARK: find tool's owner
                                            var owner: BackendlessUser?
                                            var imageUrl: String?
//                                            var ownerImage = UIImage?()
                                            
                    
                                            let userdataQuery = BackendlessDataQuery()
                                            userdataQuery.whereClause = thiswhereClause
                                            let dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
                    
                                            dataStore.find(userdataQuery, response: { (users : BackendlessCollection!) in
                        
                       
                                                if let owner = users.data.first as? BackendlessUser {
                                                    
                                                    var ownerImage = UIImage?()
                                                    
                                                    if let avatarURL = owner.getProperty("Avatar") {
//                                                        print("********")
//                                                        print(avatarURL)
//                                                        print("********")
                                                        getImageFromURL(avatarURL as! String, result: { (image) in

                                                            ownerImage = image!
                                                            
                                                            let point = ToolAnnotation(coordinate: location)
                                                            point.title = (owner.name)
                                                            point.subtitle = toolName
                                                            point.image = ownerImage
                                                            
                                                            self.mapView.addAnnotation(point)
                                                          print(image!)
                                                        })
                                                    }

                                                print(ownerImage)
                                                    
                                                
                                                }
                                             
                                                }) { (fault : Fault!) -> Void in
                                                print("Server report an error : \(fault)")
                                                   }
                                                }
                                },
                       error: { ( fault : Fault!) -> () in
                       print("Server reported an error: \(fault)")
                        })
     }

}


extension MapSearchViewController : CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let latitude = locationManager.location!.coordinate.latitude
            let longitude = locationManager.location!.coordinate.longitude
            print(longitude)
            print(latitude)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
    
    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "tools")
//        let toolAnnotation = annotation as! ToolAnnotation
//        annotationView?.image = toolAnnotation.image

        return annotationView
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView) 
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2

        
        let toolAnnotation = view.annotation as! ToolAnnotation
        let views = NSBundle.mainBundle().loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views[0] as! CustomCalloutView
        calloutView.title.text = toolAnnotation.title
        calloutView.subtitle.text = toolAnnotation.subtitle
//        calloutView.title.text = toolAnnotation.title
        let tapGesture = UITapGestureRecognizer(target: self, action: "See ToolBelter Info")
//        calloutView.starbucksPhone.addGestureRecognizer(tapGesture)
//        calloutView.starbucksPhone.userInteractionEnabled = true
        calloutView.ownerImage.image = toolAnnotation.image
        calloutView.ownerImage.layer.cornerRadius = calloutView.ownerImage.frame.size.width/2
        calloutView.ownerImage.layer.masksToBounds = true
//        calloutView.ownerImage.layer.cornerRadius = ownerImage.frame.size.width/2
        // 3
        calloutView.center = CGPointMake(view.bounds.size.width / 2, -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
    }
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.isKindOfClass(AnnotationView)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }

    


}