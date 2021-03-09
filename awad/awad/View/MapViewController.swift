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
	let titleHeader: Header = Header(imageName: "map")
	let setDestinationButton: Button = Button(image: #imageLiteral(resourceName: "setDestinationButton"))
	let model: MapModel = MapModel()
	var presenter: MapPresenterInput!
	
	var annotations: [Checkpoint] = []
	var overlays: [MKOverlay] = []
	var currentSelectedAnnotation: Checkpoint?
	var hoge: Bool = false

	override func viewDidLoad() {
		super.viewDidLoad()
		view.overrideUserInterfaceStyle = .light
		UserLocationManager.shared.requestAlwaysAuthorization()
		self.setupMap()
		self.setupView()
		self.addConstraint()
		self.presenter = MapPresenter(view: self, model: model)
		presenter?.viewDidLoad()
		mapView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		MenuBar.shared.activate(parent: self)
		MenuBar.shared.delegate = self
		self.setButton()
		self.navigationController?.removePreviousController()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		MenuBar.shared.animate()
//		self.removeUnnecessaryContents()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		MenuBar.shared.layer.opacity = 0
		titleHeader.resetForAnimation()
		setDestinationButton.layer.opacity = 0
	}
	
	@objc
	func setDestination() {
		guard let currentSelectedAnnotation = currentSelectedAnnotation else {
			return
		}
		UserLocationManager.shared.setDestination(currentSelectedAnnotation)
		let compassViewController: CompassViewController = CompassViewController()
		self.navigationController?.pushViewController(compassViewController, animated: true)
		print(UserLocationManager.shared.currentDestinationInformation!.checkpointName)
	}
}

extension MapViewController: MenuBarDelegate {
	func didMenuBarClosed() {
		setDestinationButton.isEnabled = false
		setDestinationButton.alpha = 0
	}
}

extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		guard let annotation = annotation as? Checkpoint else {
			return nil
		}
		let identifier: String = "pin"
		var annotationView: MKAnnotationView?
		
		if let dequeuedAnnotationView: MKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
			if let category: String = annotation.title {
				let annotation: CheckpointAnnotationView = CheckpointAnnotationView(annotation: annotation, reuseIdentifier: identifier, category: Category(rawValue: category) ?? .monument)
				annotationView = annotation
			}
		}
//		else {
//			if let category: String = annotation.title {
//				let annotation: CheckpointAnnotationView = CheckpointAnnotationView(annotation: annotation, reuseIdentifier: identifier, category: Category(rawValue: category) ?? .monument)
//				annotationView = annotation
//			}
//		}
		return annotationView
	}
	
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		let region: MKCoordinateRegion = mapView.region
		let latitudeDelta: CLLocationDegrees = region.span.latitudeDelta
		let longitudeDelta: CLLocationDegrees = region.span.longitudeDelta
		if !annotations.isEmpty {
			if latitudeDelta < 0.25 && longitudeDelta < 0.15 {
				hoge = true
				for annotation in annotations {
					UIView.animate(withDuration: 0.5, animations: {
						// 画像変える
						mapView.view(for: annotation)?.image = #imageLiteral(resourceName: "green_circle")
					})
				}
			} else if hoge {
				hoge = false
				for annotation in annotations {
					let annotationView: MKAnnotationView? = mapView.view(for: annotation)
					annotationView?.alpha = 0
					annotationView?.image = CheckpointIcon(name: annotation.title!)?.image
					UIView.animate(withDuration: 1, animations: {
						annotationView?.alpha = 0.7
					})
				}
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//	   if let userLocation = mapView.view(for: mapView.userLocation) {
//		userLocation.canShowCallout = false
//	   }
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//		print("updated")
//		mapView.view(for: userLocation)?.canShowCallout = false
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if view.annotation is MKUserLocation {
			return
		}

		currentSelectedAnnotation = view.annotation as! Checkpoint
		let annotations: [MKAnnotation] = mapView.annotations
		for annotation in annotations {
			if annotation is MKUserLocation {
				continue
			}
			mapView.view(for: annotation)?.alpha = 0.7
		}
		var region: MKCoordinateRegion = mapView.region
		region.center.latitude = (view.annotation?.coordinate.latitude)!
		region.center.longitude = (view.annotation?.coordinate.longitude)!
		DispatchQueue.main.async {
			mapView.setRegion(region, animated: true)
			view.alpha = 1
		}
		MenuBar.shared.closeMenu()
		setDestinationButton.isEnabled = true
		setDestinationButton.alpha = 1
	}
		
}

extension MapViewController: MapPresenterOutput {
	func initMapAddition(_ addition: MapAddition) {
		annotations = addition.annotations
		mapView.addAnnotations(annotations)
	}
}

extension MapViewController {
	func setupView() {
		titleHeader.activateConstraint(parent: view)
	}
	
	func addConstraint() {
		mapView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
			mapView.heightAnchor.constraint(equalTo: view.heightAnchor)
		])
	}
	
	func setButton() {
		view.addSubview(setDestinationButton)
		setDestinationButton.contentMode = .scaleAspectFill
		setDestinationButton.isEnabled = false
		setDestinationButton.alpha = 0
		setDestinationButton.addTarget(self, action: #selector(setDestination), for: .touchUpInside)
		setDestinationButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			setDestinationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
			setDestinationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
			setDestinationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	func setupMap() {
		let AWAJISHIMA_CENTER_LATITUDE: Double = 34.325_7
		let AWAJISHIMA_CENTER_LONGITUDE: Double = 134.813_1
		let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(AWAJISHIMA_CENTER_LATITUDE, AWAJISHIMA_CENTER_LONGITUDE)
		let region: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 60_000, longitudinalMeters: 60_000)
		mapView.setRegion(region, animated: false)
		mapView.isRotateEnabled = false
		// カメラの移動範囲を制限
//		mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: false)
		let zoomRange: MKMapView.CameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200_000)!
		mapView.setCameraZoomRange(zoomRange, animated: false)
		mapView.showsBuildings = false
		mapView.showsTraffic = false
		mapView.showsUserLocation = true
		mapView.mapType = .mutedStandard
		mapView.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
		mapView.register(CheckpointAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
		view.addSubview(mapView)
	}
	
	func removeUnnecessaryContents() {
		let legalLabel: UIView = mapView.subviews[1]
		legalLabel.alpha = 0
		let appleIconLabel: UIView = mapView.subviews[2]
		appleIconLabel.alpha = 0
	}
}
