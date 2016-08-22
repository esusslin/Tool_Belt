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
    
    var users: [BackendlessUser] = []
    
    let locationManager = CLLocationManager()

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tools = [Tool]()
   

    @IBOutlet weak var searchBar: UISearchBar!
   

    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.appDelegate.coordinate?.latitude)
        print(self.appDelegate.coordinate?.longitude)

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
        
        print((self.appDelegate.coordinate?.latitude)!)
         print((self.appDelegate.coordinate?.longitude)!)
        
                   let whereClause = "distance('\((self.appDelegate.coordinate?.latitude)!)', '\((self.appDelegate.coordinate?.longitude)!)', location.latitude, location.longitude ) < mi(6)"
                    let dataQuery = BackendlessDataQuery()
                    let queryOptions = QueryOptions()
                    queryOptions.related = ["tools", "tools.User"];
        
                    dataQuery.whereClause = whereClause
        
                    var error: Fault?
                    let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
        
        backendless.persistenceService.of(Tool.ofClass()).find(
            dataQuery,
            response: { ( tools : BackendlessCollection!) -> () in
                let currentPage = tools.getCurrentPage()
                print("Loaded \(currentPage.count) restaurant objects")
                print("Total restaurants in the Backendless starage - \(tools.totalObjects)")
                
                for tool in currentPage as! [Tool] {
                    print("Tool name = \((tool.title)!)")
                    print(tool.title!)
                 
//                    let withUser = BackendlessUser?
                    
                    let latitude = (tool.location?.latitude)!
                    let longitude = (tool.location?.longitude)!
                    
                    var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! Double, longitude as! Double)
                    
                    var owner: BackendlessUser?

                    let toolName = (tool.title)!
                    let toolDescription = (tool.toolDescription)!
                    let thiswhereClause = "objectId != '\((tool.ownerId)!)'"
                    
                    //MARK: find owner
                    
                    let userdataQuery = BackendlessDataQuery()
                    userdataQuery.whereClause = thiswhereClause
                    let dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
                    dataStore.find(userdataQuery, response: { (users : BackendlessCollection!) in
                        
                        let owner = users.data.first as? BackendlessUser
//                        print(owner)
                        
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = location
                    
                       annotation.title = (owner!.name)
                        
                        self.mapView.addAnnotation(annotation)
                        
                    }) { (fault : Fault!) -> Void in
                        print("Server report an error : \(fault)")
                    }              
                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )

    }
    
}


extension MapSearchViewController : CLLocationManagerDelegate {
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
            let span = MKCoordinateSpanMake(0.03, 0.03)
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
}