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
 
    @IBOutlet var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var venues = [Venue]()
    
    
    func fetchData() {
        let fileName = Bundle.main.path(forResource: "location", ofType: "json")
        let filePath = URL(fileURLWithPath: fileName!)
        var data : Data?
        do {
            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
        }catch let error {
            data = nil
            print("エラーがあります \(error.localizedDescription)")
        }
        //jsonファイルの1行目に"venues"を追加しました
        if let jsonData = data {
            let json = JSON(jsonData)
            if let venueJSONs = json["venues"].array {
                for venueJSON in venueJSONs {
                    if let venue = Venue.from(json: venueJSON) {
                        self.venues.append(venue)
                    }
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.325_7, 134.813_1)
 
        mapView.setCenter(location,animated:true)
    
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.42
        region.span.longitudeDelta = 0.42
 
        mapView.setRegion(region, animated: true)
        mapView.mapType = MKMapType.standard
        
        // ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        fetchData()
        mapView.addAnnotations(venues)
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
            default:
                break
            }
        }
 
}
