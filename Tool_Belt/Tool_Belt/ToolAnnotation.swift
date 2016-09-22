//
//  ToolAnnotation.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/23/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import MapKit
import Mapbox

class ToolAnnotation: MGLPointAnnotation {
    
    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//    
//    // Custom properties that we will use to customize the annotation's image.
    var image: UIImage?
    
    var toolId: String?
    var ownerId: String?
    var toolPic: UIImage?
    
    
    var reuseIdentifier: String?
    
//    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//    }

}

//// MGLAnnotation protocol reimplementation
//class CustomPointAnnotation: NSObject, MGLAnnotation {
//    
//    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//    
//    // Custom properties that we will use to customize the annotation's image.
//    var image: UIImage?
//    
//    var toolId: String?
//    
//    var reuseIdentifier: String?
//    
//    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//    }
//}