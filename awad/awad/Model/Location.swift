//
//  Location.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/27.
//

import Foundation
import CoreLocation

protocol UserLocationManagerDelegate: class {
	func locationDidUpdateToLocation(location: CLLocation)
	func locationDidUpdateHeading(newHeading: CLHeading)
}

class UserLocationManager: NSObject, CLLocationManagerDelegate {
	private let locationManager: CLLocationManager = CLLocationManager()
	private var latitude: CLLocationDegrees = 0.0
	private var longitude: CLLocationDegrees = 0.0
	weak var delegate: UserLocationManagerDelegate?
	
	static let shared: UserLocationManager = UserLocationManager()
	
	private override init() {
		super.init()
		locationManager.delegate = self
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location: CLLocation = locations.first {
			latitude = location.coordinate.latitude
			longitude = location.coordinate.longitude
			delegate?.locationDidUpdateToLocation(location: location)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		delegate?.locationDidUpdateHeading(newHeading: newHeading)
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .restricted, .denied:
			break
		case .authorizedAlways, .authorizedWhenInUse:
			locationManager.startUpdatingHeading()
			locationManager.startUpdatingLocation()
		default:
			fatalError("error")
		}

	}
	
	func getLatitude() -> CLLocationDegrees {
		return latitude
	}
	
	func getLongitude() -> CLLocationDegrees {
		return longitude
	}
	
	func getLocation() -> CLLocation? {
		return locationManager.location
	}
	
	func requestAlwaysAuthorization() {
		locationManager.requestAlwaysAuthorization()
	}
	func startUpdatingHeading() {
		locationManager.startUpdatingHeading()
	}
	
	func stopUpdatingHeading() {
		locationManager.stopUpdatingHeading()
	}
}
