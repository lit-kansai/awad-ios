//
//  CheckpointIcon.swift
//  awad
//
//  Created by tomoya tanaka on 2021/02/26.
//

import UIKit

enum CheckpointIcon {
	case monument
	case beach
	case restaurant
	case park
	case museum
	case observatory
	case shrine
	
	init?(name: String) {
		// 各都道府県に分岐して初期化
		switch name {
		case "モニュメント":
			self = .monument
		case "飲食店":
			self = .restaurant
		case "公園":
			self = .park
		case "砂浜":
			self = .beach
		case "施設":
			self = .museum
		case "展望台":
			self = .observatory
		case "神社仏閣":
			self = .shrine
		default:
			return nil
		}
	}
	
	var image: UIImage {
		switch self {
		case .monument:
			return #imageLiteral(resourceName: "monument").resizeImageForAnnotationView()
		case .restaurant:
			return #imageLiteral(resourceName: "restaurant").resizeImageForAnnotationView()
		case .beach:
			return #imageLiteral(resourceName: "beach").resizeImageForAnnotationView()
		case .park:
			return #imageLiteral(resourceName: "park").resizeImageForAnnotationView()
		case .museum:
			return #imageLiteral(resourceName: "museum").resizeImageForAnnotationView()
		case .observatory:
			return #imageLiteral(resourceName: "observatory").resizeImageForAnnotationView()
		case .shrine:
			return #imageLiteral(resourceName: "shrine").resizeImageForAnnotationView()
		}
	}
}
