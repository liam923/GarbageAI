//
//  TrashViewController.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/9/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import UIKit
import MapKit

class TrashViewController: UIViewController {
    
    var trash: Trash!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coord = CLLocationCoordinate2D(latitude: trash.location.latitude, longitude: trash.location.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 1, longitudinalMeters: 1)
        mapView.setRegion(region, animated: true)
    }

}
