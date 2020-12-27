//
//  CompassPresenter.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import Foundation
import MapKit

protocol CompassPresenterInput {
	func viewDidLoad(currentLocation: CLLocationCoordinate2D, targetLocation: CLLocationCoordinate2D)
	func updateCheckpointDirection(degree: Double)
	func updateCheckpointDistance(coordinate: CLLocationCoordinate2D)
}

protocol CompassPresenterOutput: AnyObject {
	func changeNeedleDirection(radian: Double)
	func changeCheckpointDistance(distance: Double)
}

final class CompassPresenter: CompassPresenterInput {
	
	private(set) var radian: Double = 0
	
	private weak var view: CompassPresenterOutput!
	private var model: CompassModelInput
	
	private var targetLocationLatitude: Double
	private var targetLocationLongitude: Double
	
	init(view: CompassPresenterOutput, model: CompassModelInput) {
		self.view = view
		self.model = model
		self.targetLocationLatitude = 0
		self.targetLocationLongitude = 0
	}
	
	func viewDidLoad(currentLocation: CLLocationCoordinate2D, targetLocation: CLLocationCoordinate2D) {
		targetLocationLatitude = targetLocation.latitude
		targetLocationLongitude = targetLocation.longitude
		let current: (latitude: Double, longitude: Double) = (latitude: currentLocation.latitude, longitude: currentLocation.longitude)
		let target: (latitude: Double, longitude: Double) = (latitude: targetLocationLatitude, longitude: targetLocationLongitude)
		model.setupDirection(current: current, target: target)
	}
	
	func updateCheckpointDirection(degree: Double) {
		radian = model.calcCheckpointDirection(direction: degree)
		view.changeNeedleDirection(radian: radian)
	}
	
	func updateCheckpointDistance(coordinate: CLLocationCoordinate2D) {
		let current: (latitude: Double, longitude: Double) = (latitude: coordinate.latitude, longitude: coordinate.longitude)
		let target: (latitude: Double, longitude: Double) = (latitude: targetLocationLatitude, longitude: targetLocationLongitude)
		let distance: Double = model.calcCheckpointDistance(current: current, target: target)
		view.changeCheckpointDistance(distance: distance)
	}
	
}
