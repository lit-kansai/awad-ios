//
//  NavigationController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/23.
//

import Foundation
import UIKit

extension UINavigationController {
	func removePreviousController() {
		if self.viewControllers.count >= 3 && self.viewControllers.count != 1 {
			var navigationArray: [UIViewController] = self.viewControllers // To get all UIViewController stack as Array
			navigationArray.remove(at: navigationArray.count - 2) // To remove previous UIViewController
			self.viewControllers = navigationArray
		}
	}
}
