//
//  campusAnnotations.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/23/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import Foundation

class campusAnnotations: NSObject, MKAnnotation{
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    
    init(location: CLLocationCoordinate2D, name: String) {
        self.coordinate = location
        self.title = name
    }
}
