//
//  MapPresenter.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/15.
//

import Foundation

protocol MapPresenterInput {
	func viewDidLoad()
}

protocol MapPresenterOutput: AnyObject {
	func initAnnotations(_ annotations: [CheckpointAnnotation])
}

final class MapPresenter: MapPresenterInput {
	
	private weak var view: MapPresenterOutput!
	private var model: MapModelInput
	
	init(view: MapPresenterOutput, model: MapModelInput) {
		self.view = view
		self.model = model
	}
	
	func viewDidLoad() {
		let annotations: [CheckpointAnnotation] = model.generateAnnotations()
		view.initAnnotations(annotations)
	}
	
}
