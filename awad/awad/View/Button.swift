//
//  Button.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/01.
//

import UIKit

class Button: UIButton {
	var parent: UIView?
	var constraint: NSLayoutConstraint?
	init(image: UIImage) {
		super.init(frame: .zero)
		self.setImage(image, for: .normal)
		self.imageView?.contentMode = .scaleAspectFill
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func activateConstraint(parent: UIView) {
		self.parent = parent
		parent.addSubview(self)
		NSLayoutConstraint.activate([
			self.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1)
		])
		constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: self.frame.width * 2)
		parent.addConstraint(constraint!)
	}
	
	func setupForAnimation(constant: CGFloat) {
		self.constraint?.constant = constant
	}
	
	func resetLocation() {
		self.constraint?.constant = self.frame.width * 2
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
