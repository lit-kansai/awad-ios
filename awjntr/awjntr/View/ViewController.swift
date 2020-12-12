//
//  ViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/05.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    @IBOutlet var mapView:MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(34.3257,134.8131)
 
        mapView.setCenter(location,animated:true)
 
    
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.42
        region.span.longitudeDelta = 0.42
 
        mapView.setRegion(region,animated:true)
        mapView.mapType = MKMapType.standard
        
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
    }
    
    // 許可を求めるためのdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            //許可されていない場合
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            //許可されている場合
            case .restricted, .denied:
                break
            case .authorizedAlways, .authorizedWhenInUse:
            // 現在地の取得を開始
                manager.startUpdatingLocation()
                break
            default:
                break
            }
        }
 
}

