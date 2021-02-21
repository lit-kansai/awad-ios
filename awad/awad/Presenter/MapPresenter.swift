//
//  MapPresenter.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/15.
//

import Foundation
import MapKit

protocol MapPresenterInput {
	func viewDidLoad()
	func setDestination(_ destination: Checkpoint)
}

protocol MapPresenterOutput: AnyObject {
	func initMapAddition(_ addition: MapAddition)
}

final class MapPresenter: MapPresenterInput {
	
	private weak var view: MapPresenterOutput!
	private var model: MapModelInput
	private(set) var currentDestination: Checkpoint?
	
	init(view: MapPresenterOutput, model: MapModelInput) {
		self.view = view
		self.model = model
	}
	
	func viewDidLoad() {
		let mapAddition: MapAddition = model.generateAdditions()
		view.initMapAddition(mapAddition)
	}
		
	func setDestination(_ destination: Checkpoint) {
		currentDestination = destination
		print("destionation set")
	}
}
