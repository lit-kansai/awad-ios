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
		self.contentMode = .scaleAspectFill
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func activateConstraint(parent: UIView) {
		self.parent = parent
		parent.addSubview(self)
		constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: -250)
		NSLayoutConstraint.activate([
			self.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 0.6),
			self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 80),
			self.heightAnchor.constraint(equalToConstant: 70),
			constraint!
		])
//		parent.addConstraint(constraint!)
	}
	
	func setupForAnimation() {
	}
	
	func resetForAnimation() {
		self.layer.opacity = 0
		self.constraint?.constant = -250
	}
	
	func animate() {
		self.layer.opacity = 1
		self.constraint?.constant = -15
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
			self.parent!.layoutIfNeeded()
		}, completion: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
