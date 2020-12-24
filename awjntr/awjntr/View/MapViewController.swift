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
	
	let window: UIView = UIView()
	let destinationLabel: UILabel = UILabel()
	var annotations: [MKAnnotation] = []
	var overlays: [MKOverlay] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.overrideUserInterfaceStyle = .light
		
		let AWAJISHIMA_CENTER_LATITUDE: Double = 34.325_7
		let AWAJISHIMA_CENTER_LONGITUDE: Double = 134.813_1
		let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(AWAJISHIMA_CENTER_LATITUDE, AWAJISHIMA_CENTER_LONGITUDE)
		let region: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 60_000, longitudinalMeters: 60_000)
		mapView.delegate = self
		mapView.isRotateEnabled = false
		mapView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
		mapView.center = view.center
		mapView.setRegion(region, animated: false)
		mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: false)
		let zoomRange: MKMapView.CameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200_000)!
		mapView.setCameraZoomRange(zoomRange, animated: false)
		view.addSubview(mapView)
	
		let button: UIButton = UIButton()
		button.frame.size = CGSize(width: 50, height: 50)
		button.center = CGPoint(x: view.frame.maxX - 50, y: 100)
		button.setTitle("コンパス", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = .white
		button.addTarget(nil, action: #selector(openCompassViewController), for: .touchUpInside)
		view.addSubview(button)
		
		window.backgroundColor = .white
		window.frame.size = CGSize(width: self.view.frame.width - 50, height: 150)
		window.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 100)
		window.layer.cornerRadius = 10
		window.alpha = 0
		self.view.addSubview(window)
		
		destinationLabel.frame = CGRect(x: 20, y: 20, width: window.frame.width - 50, height: window.frame.height / 4)
		destinationLabel.text = "hoge"
		destinationLabel.font = UIFont(name: "HiraginoSans-W6", size: 24)
		window.addSubview(destinationLabel)
		
		let registerButton: UIButton = UIButton()
		registerButton.frame.size = CGSize(width: window.frame.width - 50, height: window.frame.height / 3)
		registerButton.center = CGPoint(x: window.frame.width / 2, y: window.bounds.maxY - 50)
		registerButton.setTitle("目的地に設定する", for: .normal)
		registerButton.setTitleColor(.white, for: .normal)
		registerButton.backgroundColor = UIColor.systemGreen
		registerButton.layer.cornerRadius = 10
		window.addSubview(registerButton)
		presenter?.viewDidLoad()
	}
	
	@objc
	func openCompassViewController() {
		presenter?.transition()
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
			if let subtitle: String? = annotation.subtitle, let category: String = subtitle {
				let annotation: CheckpointAnnotationView = CheckpointAnnotationView(annotation: annotation, reuseIdentifier: identifier, category: Category(rawValue: category) ?? .monument)
				
				annotationView = annotation
			}
		}
		return annotationView
	}
	
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		let region: MKCoordinateRegion = mapView.region
		let latitudeDelta: CLLocationDegrees = region.span.latitudeDelta
		let longitudeDelta: CLLocationDegrees = region.span.longitudeDelta
		if !annotations.isEmpty {
			if latitudeDelta < 0.25 && longitudeDelta < 0.15 {
				for annotation in annotations {
					UIView.animate(withDuration: 0.5, animations: {
						mapView.view(for: annotation)?.alpha = 0
					})
				}
				for overlay in overlays {
					UIView.animate(withDuration: 0.5, animations: {
						mapView.renderer(for: overlay)?.alpha = 0.8
					})
				}
				
			} else if mapView.view(for: annotations.first!)?.alpha == 0 {
				for annotation in annotations {
					UIView.animate(withDuration: 0.5, animations: {
						mapView.view(for: annotation)?.alpha = 0.5
					})
				}
				for overlay in overlays {
					UIView.animate(withDuration: 0.5, animations: {
						mapView.renderer(for: overlay)?.alpha = 0
					})
				}
			} else {
				print("error")
			}
		}
		
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

		// rendererを生成.
		let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)

		// 円の内部を赤色で塗りつぶす.
		myCircleView.fillColor = UIColor.systemGreen
		// 円を透過させる.
		myCircleView.alpha = 0

		// 円周の線の太さ.
		myCircleView.lineWidth = 1.5

		return myCircleView
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		let annotations: [MKAnnotation] = mapView.annotations
		for annotation in annotations {
			mapView.view(for: annotation)?.alpha = 0.5
		}
		var region: MKCoordinateRegion = mapView.region
		region.center.latitude = (view.annotation?.coordinate.latitude)!
		region.center.longitude = (view.annotation?.coordinate.longitude)!
		region.span.latitudeDelta = 0.3
		region.span.longitudeDelta = 0.3
		DispatchQueue.main.async {
			mapView.setRegion(region, animated: true)
			view.alpha = 1
		}
		destinationLabel.text = view.annotation?.subtitle!
		window.alpha = 1
	}
		
}

extension MapViewController: MapPresenterOutput {
	func initMapAddition(_ addition: MapAddition) {
		annotations = addition.annotations
		overlays = addition.circles
		mapView.addAnnotations(annotations)
		mapView.addOverlays(overlays)
	}
}

extension MapViewController: TransitionRouterDelegate {
	func transition(to viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		present(viewController, animated: animated, completion: completion)
	}
}
