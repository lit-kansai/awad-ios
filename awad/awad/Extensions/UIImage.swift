//
//  UIImage.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/26.
//

import UIKit

extension UIImage {
	func resizeImageForAnnotationView() -> UIImage {
		let size: CGSize = CGSize(width: 30, height: 30)
		UIGraphicsBeginImageContext(size)
		self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		return resizedImage!
	}
}
