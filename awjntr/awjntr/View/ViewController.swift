//
//  ViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/05.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
 
    @IBOutlet var mapView:MKMapView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(34.3257,134.8131)
 
        mapView.setCenter(location,animated:true)
 
    
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
 
        mapView.setRegion(region,animated:true)
 
       
        mapView.mapType = MKMapType.standard
    }
 
}

