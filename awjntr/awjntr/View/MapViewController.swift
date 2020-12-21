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
		mapView.isRotateEnabled = false
		mapView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
		mapView.center = view.center
		let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.325_7, 134.813_1)
		let region: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 60_000, longitudinalMeters: 60_000)
		mapView.setRegion(region, animated: false)
		mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: false)
		
		// マップのズーム率を制限
		let zoomRange: MKMapView.CameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200_000)!
		mapView.setCameraZoomRange(zoomRange, animated: false)
		// マップの表示される範囲を制限
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
		let identifier: String = "pin"
		var annotationView: MKAnnotationView?

		if let dequeuedAnnotationView: MKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
			annotationView = dequeuedAnnotationView
		} else {
			let annotation: MKAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			let pinImage: UIImage? = #imageLiteral(resourceName: "slime")
			let size: CGSize = CGSize(width: 50, height: 50)
			UIGraphicsBeginImageContext(size)
			pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
			let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
			annotation.image = resizedImage
			annotation.displayPriority = .required
			annotation.canShowCallout = true
			annotationView = annotation
		}
		return annotationView
	}
	
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		let region: MKCoordinateRegion = mapView.region
		let annotations: [MKAnnotation] = mapView.annotations
		let latitudeDelta: CLLocationDegrees = region.span.latitudeDelta
		let longitudeDelta: CLLocationDegrees = region.span.longitudeDelta
		if latitudeDelta < 0.25 && longitudeDelta < 0.15 {
			for annotation in annotations {
				UIView.animate(withDuration: 0.5, animations: {
					mapView.view(for: annotation)?.alpha = 0
				})
			}
		} else {
			for annotation in annotations {
				UIView.animate(withDuration: 0.5, animations: {
					mapView.view(for: annotation)?.alpha = 1
				})
			}
		}
		
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

		// rendererを生成.
		let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)

		// 円の内部を赤色で塗りつぶす.
		myCircleView.fillColor = UIColor(cgColor: CGColor(red: 27, green: 227, blue: 160, alpha: 0.9))

		// 円を透過させる.
		myCircleView.alpha = 0.8

		// 円周の線の太さ.
		myCircleView.lineWidth = 1.5

		return myCircleView
	}
		
}

extension MapViewController: MapPresenterOutput {
	func initMapAddition(_ addition: MapAddition) {
		mapView.addAnnotations(addition.annotations)
		mapView.addOverlays(addition.circles)
	}
}
