//
//  ToolAnnotation.swift
//  Tool_Belt
//
//  Created by Emmet Susslin on 8/23/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import MapKit

class ToolAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
   
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
    }

}
