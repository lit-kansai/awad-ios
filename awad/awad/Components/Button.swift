//
//  Button.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/01.
//

import UIKit

class Button: UIButton {
	var parent: UIView?
	init(image: UIImage) {
		super.init(frame: .zero)
		self.setImage(image, for: .normal)
		self.imageView?.contentMode = .scaleAspectFit
	}
	
//	func resetLocation() {
//		print("resetLocation")
//		self.center.x = self.frame.width * 2
//	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
