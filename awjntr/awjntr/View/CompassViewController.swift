//
//  CompassViewController.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {
	private var presenter: CompassPresenterInput?
	func inject(presenter: CompassPresenterInput) {
		self.presenter = presenter
	}
	
	var locationManager: CLLocationManager!
	
	let needleImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "needle"))
	let distanceTextLabel: UILabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.overrideUserInterfaceStyle = .light
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager = CLLocationManager()
			locationManager.delegate = self
			locationManager.headingOrientation = .portrait
			locationManager.startUpdatingHeading()
			if let location = locationManager.location {
				let latitude: Double = location.coordinate.latitude
				let longitude: Double = location.coordinate.longitude
				presenter?.viewDidLoad(latitude: latitude, longitude: longitude)
			} else {
				locationManager.requestWhenInUseAuthorization()
			}

		}
		
		let distance: Int = 1_000
		distanceTextLabel.font = UIFont(name: "HiraginoSans-W6", size: 24)
		distanceTextLabel.frame.size = CGSize(width: view.frame.width / 2, height: 100)
		distanceTextLabel.center = CGPoint(x: view.frame.width / 2, y: 200)
		distanceTextLabel.textAlignment = NSTextAlignment.center
		let attrDistanceText: NSMutableAttributedString = NSMutableAttributedString(string: "あと\(distance)m")
		attrDistanceText.addAttributes([
			.foregroundColor: UIColor.blue,
			.font: UIFont(name: "HiraginoSans-W6", size: 36) as Any
		], range: _NSRange(location: 2, length: String(distance).count))
		distanceTextLabel.attributedText = attrDistanceText
		view.addSubview(distanceTextLabel)
		
		needleImageView.frame.size = CGSize(width: view.frame.width * 0.7, height: view.frame.width * 0.7)
		needleImageView.contentMode = .scaleAspectFit
		needleImageView.center = view.center
		view.addSubview(needleImageView)
		
		let button: UIButton = UIButton()
		button.frame.size = CGSize(width: 200, height: 50)
		button.center = CGPoint(x: view.center.x, y: view.frame.maxY - 100)
		button.setTitle("閉じる", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = .white
		button.addTarget(nil, action: #selector(closeCompass), for: .touchUpInside)
		view.addSubview(button)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if CLLocationManager.locationServicesEnabled() {
			locationManager.stopUpdatingHeading()
		}
	}
	
	@objc
	func closeCompass() {
		self.dismiss(animated: true, completion: nil)
	}
}

extension CompassViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .restricted, .denied:
			break
		case .authorizedAlways, .authorizedWhenInUse:
			locationManager.startUpdatingHeading()
		default:
			fatalError("error")
		}
	}
	
	// 方角が更新された時
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		presenter?.updateCheckpointDirection(degree: newHeading.magneticHeading)
	}
	
	// 座標が更新された時
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
	}
}

extension CompassViewController: CompassPresenterOutput {
	func changeNeedleDirection(radian: Double) {
		needleImageView.transform = CGAffineTransform(rotationAngle: CGFloat(radian))
	}
}
