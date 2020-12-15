//
//  CompassPresenter.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import Foundation

protocol CompassPresenterInput {
	func updateCheckpointDirection(degree: Double)
	func viewDidLoad(latitude: Double, longitude: Double)
}

protocol CompassPresenterOutput: AnyObject {
	func changeNeedleDirection(radian: Double)
}

final class CompassPresenter: CompassPresenterInput {
	private(set) var radian: Double = 0
	
	private weak var view: CompassPresenterOutput!
	private var model: CompassModelInput
	
	init(view: CompassPresenterOutput, model: CompassModelInput) {
		self.view = view
		self.model = model
	}
	
	func updateCheckpointDirection(degree: Double) {
		radian = model.calcCheckpointDirection(direction: degree)
		view.changeNeedleDirection(radian: radian)
	}
	
	func viewDidLoad(latitude: Double, longitude: Double) {
		model.setupDirection(latitude, longitude)
	}
}
