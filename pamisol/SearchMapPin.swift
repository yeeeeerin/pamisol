//
//  SearchMapPin.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 20..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SearchMapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title

    }
}
