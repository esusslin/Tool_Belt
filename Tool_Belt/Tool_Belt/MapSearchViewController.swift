//
//  MapSearchViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/18/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController, UISearchBarDelegate {
    
    let backendless = Backendless.sharedInstance()
    
    
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked( searchbar: UISearchBar) {
        searchbar.resignFirstResponder()
        tools = []
        
        func findContactsByAge(userId:String) {
            

           let whereClause = "distance( '\(self.appDelegate.coordinate?.latitude)', '\(self.appDelegate.coordinate?.longitude)', coordinates.latitude, coordinates.longitude ) < mi(6)"
            let dataQuery = BackendlessDataQuery()
            dataQuery.whereClause = whereClause
            
            var error: Fault?
            let bc = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
            if error == nil {
                print("Tools have been found: \(bc.data)")
            }
            else {
                print("Server reported an error: \(error)")
            }
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
       
        
        let searchTerm = String(searchBar.text!)
        
        
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
}