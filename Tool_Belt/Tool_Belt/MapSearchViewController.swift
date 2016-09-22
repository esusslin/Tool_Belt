//
//  MapSearchViewController.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/18/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//
//
//import UIKit
//import MapKit
//import CoreLocation
//
//class MapSearchViewController: UIViewController, UISearchBarDelegate {
//    
//    let backendless = Backendless.sharedInstance()
//    
////    var users: [BackendlessUser] = []
//    
//    let locationManager = CLLocationManager()
//
//    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    
//    var mask: CALayer!
//    var animation: CABasicAnimation!
//    
//    var tools = [Tool]()
//    var users = [BackendlessUser]()
//    
//    var avatarImagesDictionary: NSMutableDictionary?
//    var avatarDictionary: NSMutableDictionary?
//   
//    @IBOutlet var mainView: UIView!
//
//    @IBOutlet weak var overlay: UIView!
//    
//    @IBOutlet weak var virginSearchBar: UISearchBar!
//    
//    @IBOutlet weak var virginFindButton: UIButton!
//    @IBOutlet weak var searchBar: UISearchBar!
//   
//
//    
//    @IBOutlet weak var mapView: MKMapView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        virginFindButton.layer.cornerRadius = 8.0
//        virginFindButton.layer.masksToBounds = true
//        
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//        
////        mapView.showsUserLocation = true
////        mapView.delegate = self
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    @IBAction func virginFindButtonPressed(sender: AnyObject) {
//        
//        animateLaunch(UIImage(named: "wrench-1")!)
//    }
//    
//
//    @IBAction func buttonBitch(sender: UIBarButtonItem) {
//        findTools()
//    }
//    
//    func findTools() {
//            
//            let whereClause = "title LIKE '\((searchBar.text)!)' AND distance('\((self.appDelegate.coordinate?.latitude)!)', '\((self.appDelegate.coordinate?.longitude)!)', location.latitude, location.longitude ) < mi(6)"
//            let dataQuery = BackendlessDataQuery()
//            let queryOptions = QueryOptions()
//            queryOptions.related = ["tools"]
//            
//            dataQuery.whereClause = whereClause
//            
//            var error: Fault?
//            let tools = Backendless.sharedInstance().data.of(Tool.ofClass()).find(dataQuery, fault: &error)
//            
//            if error == nil {
//                print("Contacts have been found: \(tools.data)")
//            }
//            else {
//                print("Server reported an error: \(error)")
//            }
//            
//            let currentPage = tools.getCurrentPage()
//            
//            for tool in currentPage as! [Tool] {
//                
//                let latitude = (tool.location?.latitude)!
//                let longitude = (tool.location?.longitude)!
//                
//                var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! Double, longitude as! Double)
//                
//                let toolName = (tool.title)!
//                
//                
//                
//                
//////                let point = ToolAnnotation(coordinate: location)
////                point.title = toolName
//////                point.image = UIImage
////                self.mapView.addAnnotation(point)
//            }
//        
//
//     }
//    
//    func animateLaunch(image: UIImage) {
//        
//        //        self.view.backgroundColor = bgColor
//        
//        // Create and apply mask
//        
//        mask = CALayer()
//        mask.contents = image.CGImage
//        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
//        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        mask.position = CGPoint(x: mainView.frame.width / 2.0, y: mainView.frame.height / 2.0)
//        mainView.layer.mask = mask
//        
//        animateDecreaseSize()
//        
//    }
//    
//    func animateDecreaseSize() {
//        
//        let decreaseSize = CABasicAnimation(keyPath: "bounds")
//        decreaseSize.delegate = self
//        decreaseSize.duration = 0.5
//        decreaseSize.fromValue = NSValue(CGRect: mask!.bounds)
//        decreaseSize.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 80, height: 80))
//        
//        decreaseSize.fillMode = kCAFillModeForwards
//        decreaseSize.removedOnCompletion = false
//        
//        mask.addAnimation(decreaseSize, forKey: "bounds")
//        
//        
//        
//    }
//    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        animateIncreaseSize()
//    }
//    
//    func animateIncreaseSize() {
//        
//        animation = CABasicAnimation(keyPath: "bounds")
//        animation.duration = 0.75
//        animation.fromValue = NSValue(CGRect: mask!.bounds)
//        animation.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: 4000, height: 4000))
//        
//        animation.fillMode = kCAFillModeForwards
//        animation.removedOnCompletion = false
//        
//        mask.addAnimation(animation, forKey: "bounds")
//        
//        // Fade out overlay
//        UIView.animateWithDuration(0.75, animations: { () -> Void in
//            self.overlay.alpha = 0
//        })
//        
//        findTools()
//    }
//}
//
//
//
//
//extension MapSearchViewController : CLLocationManagerDelegate, MKMapViewDelegate {
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            
//            let latitude = locationManager.location!.coordinate.latitude
//            let longitude = locationManager.location!.coordinate.longitude
//            print(longitude)
//            print(latitude)
//            let span = MKCoordinateSpanMake(0.1, 0.1)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//            mapView.setRegion(region, animated: true)
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("error:: (error)")
//    }
//    
//    
//    //MARK: MKMapViewDelegate
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        mapView.setRegion(region, animated: true)
//    }
//    
//    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        if annotation is MKUserLocation
//        {
//            return nil
//        }
//        
//        var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
//        
//        if annotationView == nil{
//            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
//            annotationView?.canShowCallout = false
//        }else{
//            annotationView?.annotation = annotation
//        }
//        annotationView?.image = UIImage(named: "tools")
////        let toolAnnotation = annotation as! ToolAnnotation
////        annotationView?.image = toolAnnotation.image
//
//        return annotationView
//    }
//    
//    func mapView(mapView: MKMapView,
//                 didSelectAnnotationView view: MKAnnotationView) 
//    {
//        // 1
//        if view.annotation is MKUserLocation
//        {
//            // Don't proceed with custom callout
//            return
//        }
//        // 2
//
//        
//        let toolAnnotation = view.annotation as! ToolAnnotation
////        let views = NSBundle.mainBundle().loadNibNamed("CustomCalloutView", owner: nil, options: nil)
////        let calloutView = views[0] as! CustomCalloutView
////        calloutView.title.text = toolAnnotation.title
////        calloutView.subtitle.text = toolAnnotation.subtitle
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: "See ToolBelter Info")
//
//    }
//    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
//        if view.isKindOfClass(AnnotationView)
//        {
//            for subview in view.subviews
//            {
//                subview.removeFromSuperview()
//            }
//        }
//    }
//}
