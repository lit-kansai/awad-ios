//
//  CompassPresenter.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import Foundation
import MapKit

protocol CompassPresenterInput {
	func updateCheckpointDirection(degree: Double)
	func updateCheckpointDistance()
}

protocol CompassPresenterOutput: AnyObject {
	func changeNeedleDirection(radian: Double)
	func changeCheckpointDistance(distance: Double)
}

final class CompassPresenter: CompassPresenterInput {
	
	private weak var view: CompassPresenterOutput!
	private var model: CompassModelInput
	
	init(view: CompassPresenterOutput, model: CompassModelInput) {
		self.view = view
		self.model = model
	}
	
	func updateCheckpointDirection(degree: Double) {
		let radian: Double = UserLocationManager.shared.calcCheckpointDirection(direction: degree)
		view.changeNeedleDirection(radian: radian)
	}
	
	func updateCheckpointDistance() {
		let distance: Double = UserLocationManager.shared.calcDistanceToDestination()
		view.changeCheckpointDistance(distance: distance)
	}
	
}
