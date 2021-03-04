//
//  StackViewRow.swift
//  awad
//
//  Created by tomoya tanaka on 2021/03/02.
//

import UIKit

class RegisterViewButton: UIButton {
	
	init(text: String) {
		super.init(frame: .zero)
		self.setTitle(text, for: .normal)
		self.setTitleColor(UIColor.turquoiseColor(), for: .normal)
		self.titleLabel?.font = UIFont(name: "Keifont", size: 36)
		self.backgroundColor = .white
		self.layer.cornerRadius = 10
		self.titleLabel?.adjustsFontSizeToFitWidth = true
		self.titleLabel?.numberOfLines = 1
		self.titleLabel?.minimumScaleFactor = 0.5
		self.titleLabel?.lineBreakMode = .byClipping
		self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override var isHighlighted: Bool {
		didSet {
			updateColors()
		}
	}
	
	private func updateColors() {
		if isHighlighted {
			self.titleLabel?.layer.opacity = 0.5
		} else {
			self.titleLabel?.layer.opacity = 1
		}
	}
}
