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

class UserLocationManager: NSObject {
	let locationManager: CLLocationManager = CLLocationManager()
	// 目的地
	private(set) var currentDestinationInformation: Checkpoint?
	private(set) var location: CLLocation?
	var isArrived: Bool = false
	// 目的地までの距離
	var distance: Int = 0
	
	private(set) var originDegree: Double = 0
	private(set) var currentDegree: Double = 0
	
	weak var delegate: UserLocationManagerDelegate?
	
	static let shared: UserLocationManager = UserLocationManager()
	
	private override init() {
		super.init()
		locationManager.delegate = self
	}
	
	private func toRadian(_ angle: Double) -> Double {
		return angle * Double.pi / 180
	}
	
	func setDestination(_ destination: Checkpoint) {
		self.currentDestinationInformation = destination
		let location: CLLocation = CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude)
		self.setLocation(location)
	}
	
	func setLocation(_ location: CLLocation) {
		self.location = location
	}
	
	func resetDestination() {
		self.currentDestinationInformation = nil
		self.location = nil
		self.isArrived = false
	}
	
	// 目的地まで角度を計算
	func initOriginDegree() {
		guard let userLocation = locationManager.location
		else { return }
		let currentLatitude: Double = toRadian(userLocation.coordinate.latitude)
		let currentLongitude: Double = toRadian(userLocation.coordinate.longitude)
		guard let destination = location
		else { return }
		let targetLatitude: Double = toRadian(destination.coordinate.latitude)
		let targetLongitude: Double = toRadian(destination.coordinate.longitude)
		let difLongitude: Double = targetLongitude - currentLongitude
		let y: Double = sin(difLongitude)
		let x: Double = cos(currentLatitude) * tan(targetLatitude) - sin(currentLatitude) * cos(difLongitude)
		let p: Double = atan2(y, x) * 180 / Double.pi
		if p < 0 {
			originDegree = Double(360 + atan2(y, x) * 180 / Double.pi)
		} else {
			originDegree = Double(atan2(y, x) * 180 / Double.pi)
		}
	}
	
	func requestAlwaysAuthorization() {
		locationManager.requestAlwaysAuthorization()
	}
	
	// 現在地までの距離を計算
	func calcDistanceToDestination() -> Int {
		if let destination: CLLocation = location {
			let distanceToDestination: CLLocationDistance? = locationManager.location?.distance(from: destination)
			if let distanceToDestination: CLLocationDistance = distanceToDestination {
				distance = Int(distanceToDestination)
			} else {
				print("error")
				distance = 500
			}
			return distance
		}
		return 0
	}
	
	func calcCheckpointDirection(direction: Double) -> Double {
		let radian: Double = toRadian((originDegree - Double(direction)) - currentDegree)
		currentDegree = radian
		return radian
	}
	
}

extension UserLocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location: CLLocation = locations.first {
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
}
