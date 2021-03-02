//
//  Background.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/31.
//

import UIKit

class BackgroundUIImageView: UIImageView {
	var parent: UIView?
	
	init(imageName: String) {
		let image: UIImage = UIImage(named: imageName)!
		super.init(image: image)
		self.contentMode = .scaleAspectFill
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func activateConstraint(parent: UIView) {
		self.parent = parent
		parent.addSubview(self)
		NSLayoutConstraint.activate([
			self.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
			self.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
			self.widthAnchor.constraint(equalTo: parent.widthAnchor),
			self.heightAnchor.constraint(equalTo: parent.heightAnchor)
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
