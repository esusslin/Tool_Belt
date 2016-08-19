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
    
    var tools = [Tool]()
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let defaults = NSUserDefaults.standardUserDefaults()
       
        
        let searchTerm = String(searchBar.text!)
        
        var query = BackendlessGeoQuery.queryWithPoint(
            GEO_POINT(latitude: 32.555, longitude: -97.667),
            radius: 270, units: MILES,
            categories: ["Tool"]
            ) as! BackendlessGeoQuery
        query.includeMeta = true
        
        backendless.geoService.getPoints(
            query,
            response: { (var points : BackendlessCollection!) -> () in
                print("Total points in radius \(points.totalObjects)")
                self.nextPageAsync(points)
            },
            error: { (var fault : Fault!) -> () in
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
            let span = MKCoordinateSpanMake(0.03, 0.03)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}