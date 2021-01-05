//
//  Router.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/23.
//

import UIKit

protocol TransitionRouterDelegate: class {
	func transition(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

class TransitionRouter {
	
	private weak var transitionRouterDelegate: TransitionRouterDelegate?
	
	init(delegate transitionRouterDelegate: TransitionRouterDelegate) {
		self.transitionRouterDelegate = transitionRouterDelegate
	}
	
	func transition() {
		guard let destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CompassViewController") as? CompassViewController
		else { return }
		destinationViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
		let model: CompassModel = CompassModel()
		let presenter: CompassPresenter = CompassPresenter(view: destinationViewController, model: model)
		destinationViewController.inject(presenter: presenter)
		transitionRouterDelegate?.transition(to: destinationViewController, animated: true, completion: nil)
	}
	
}
