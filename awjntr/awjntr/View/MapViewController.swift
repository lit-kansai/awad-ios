//
//  ViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/05.
//

import UIKit
import MapKit
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    @IBOutlet var mapView:MKMapView!
    var locationManager: CLLocationManager!
    var venues = [Venue]()
    
    
    func fetchData() {
        let fileName = Bundle.main.path(forResource: "", ofType: "json")
        let filePath = URL(fileURLWithPath: fileName!)
        var data : Data?
        do {
            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
        }catch let error {
            data = nil
            print("エラーがあります \(error.localizedDescription)")
        }
         
//        if let jsonData = data {
//            let json = JSON(data: jsonData)
//            if let venueJSONs = json["response"]["venues"].array{
//                for venueJSON in venueJSONs {
//                    if let venue = Venue.from(json: venueJSON) {
//                        self.venues.append(venue)
//                    }
//                }
//            }
//
//
//        }
        
        
    }
    
    
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
        
        //ピンを配置
//        let spot = Venue(name: "明石海峡大橋撮影スポット", category: "展望台", coordinate: CLLocationCoordinate2D(latitude: 34.58412, longitude: 135.01757))
//        mapView.addAnnotation(spot)
        
        mapView.delegate = self
        fetchData()
        
        //(エラーあり)配列で存在しない添字にアクセスしてるかオブジェクトがnilになってるかだと睨んでる
        mapView.addAnnotation(venues as! MKAnnotation)
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



