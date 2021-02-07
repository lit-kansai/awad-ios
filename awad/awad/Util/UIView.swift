//
//  UIView.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/03.
//

import UIKit
enum BorderPosition {
	case top
	case left
	case right
	case bottom
}

extension UIView {
	/// 特定の場所にborderをつける
	///
	/// - Parameters:
	///   - width: 線の幅
	///   - color: 線の色
	///   - position: 上下左右どこにborderをつけるか
	func addBorder(width: CGFloat, color: UIColor, position: BorderPosition) {

		let border: CALayer = CALayer()

		switch position {
		case .top:
			border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
			border.backgroundColor = color.cgColor
			self.layer.addSublayer(border)
		case .left:
			border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
			border.backgroundColor = color.cgColor
			self.layer.addSublayer(border)
		case .right:
			print(self.frame.width)

			border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
			border.backgroundColor = color.cgColor
			self.layer.addSublayer(border)
		case .bottom:
			border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
			border.backgroundColor = color.cgColor
			self.layer.addSublayer(border)
		}
	}
}
