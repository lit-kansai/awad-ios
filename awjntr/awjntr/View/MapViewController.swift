//
//  MapViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/15.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	let mapView: MKMapView = MKMapView()
	private var presenter: MapPresenterInput?
	func inject(presenter: MapPresenterInput) {
		self.presenter = presenter
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.overrideUserInterfaceStyle = .light
		
		mapView.delegate = self
		mapView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
		mapView.center = view.center
		let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.325_7, 134.813_1)
		var region: MKCoordinateRegion = MKCoordinateRegion()
		region.center = location
		region.span.latitudeDelta = 0.42
		region.span.longitudeDelta = 0.42
		mapView.setRegion(region, animated: false)
		// マップのズーム率を制限
		let zoomRange: MKMapView.CameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200_000)!
		mapView.setCameraZoomRange(zoomRange, animated: false)
		// マップの表示される範囲を制限
		let coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 60_000, longitudinalMeters: 30_000)
		mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: coordinateRegion), animated: false)
		view.addSubview(mapView)
		
		presenter?.viewDidLoad()
    }

}

extension MapViewController: CLLocationManagerDelegate {
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

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let identifier = "pin"
		var annotationView: MKAnnotationView!
		
		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			
			let pinImage = UIImage(named: "slime")
			let size = CGSize(width: 50, height: 50)
			UIGraphicsBeginImageContext(size)
			pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
			let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

			annotationView?.image = resizedImage
		
		}
		
		annotationView.displayPriority = .required
		annotationView.annotation = annotation
		annotationView.canShowCallout = true
		
		return annotationView
	}
}

extension MapViewController: MapPresenterOutput {
	func initAnnotations(_ annotations: [CheckpointAnnotation]) {
		mapView.addAnnotations(annotations)
	}
}
