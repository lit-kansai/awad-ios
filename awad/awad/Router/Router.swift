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
//	static let shared = TransitionRouter()
	
	init(delegate transitionRouterDelegate: TransitionRouterDelegate) {
		self.transitionRouterDelegate = transitionRouterDelegate
	}
	
	func transition() {
		let destinationViewController: CompassViewController = CompassViewController()
		destinationViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
		transitionRouterDelegate?.transition(to: destinationViewController, animated: true, completion: nil)
	}
	
	func transitionToCompassViewController() {
		let destinationViewController: CompassViewController = CompassViewController()
		destinationViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
		transitionRouterDelegate?.transition(to: destinationViewController, animated: true, completion: nil)
	}
		
}
