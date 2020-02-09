//
//  TrashMapView.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/9/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class TrashMapView: MKMapView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Database.shared.getLocations { (points) in
            for point in points {
                let coord = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coord
                self.addAnnotation(annotation)
                print(annotation.coordinate)
            }
        }
        
        self.userTrackingMode = .follow
    }
    
}
