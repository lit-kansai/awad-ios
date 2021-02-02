//
//  Header.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/31.
//

import UIKit

class Header: UIImageView {
	var parent: UIView?
	var constraint: NSLayoutConstraint?
	init(imageName: String) {
		let image: UIImage = UIImage(named: imageName)!
		super.init(image: image)
		self.contentMode = .scaleAspectFit
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func activateConstraint(parent: UIView) {
		self.parent = parent
		parent.addSubview(self)
		NSLayoutConstraint.activate([
			self.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 0.6),
			self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 50)
		])
		constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: -self.frame.width)
		parent.addConstraint(constraint!)
	}
	
	func setupForAnimation() {
		self.constraint?.constant = -15
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
