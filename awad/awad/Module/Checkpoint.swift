//
//  Checkpoint.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/23.
//

import Foundation
import MapKit

final class Checkpoint: NSObject, MKAnnotation {
	let coordinate: CLLocationCoordinate2D
	let title: String?
	let subtitle: String?
	let mission: String
	let checkpointName: String
	let stampImageName: String
	let stampDescription: String
	
	init(title: String, subtitle: String, latitude: Double, longitude: Double, mission: String, checkpointName: String, stampImageName: String, stampDescription: String) {
		let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		self.coordinate = coordinate
		// NOTE: 書かないと、titleとsubtitleは絶対必要ですと怒られます。(MKAnnotationViewが必須としている)
		self.title = title
		self.subtitle = subtitle
		self.mission = mission
		self.checkpointName = checkpointName
		self.stampImageName = stampImageName
		self.stampDescription = stampDescription
		super.init()
	}
}

final class CheckpointAnnotationView: MKAnnotationView {
	
	init(annotation: MKAnnotation, reuseIdentifier: String, category: Category) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		let pinImage: UIImage?
		switch category {
		case .monument:
			pinImage = #imageLiteral(resourceName: "monument")
		case .restaurant:
			pinImage = #imageLiteral(resourceName: "restaurant")
		case .park:
			pinImage = #imageLiteral(resourceName: "park")
		case .beach:
			pinImage = #imageLiteral(resourceName: "beach")
		case .museum:
			pinImage = #imageLiteral(resourceName: "museum")
		case .observatory:
			pinImage = #imageLiteral(resourceName: "observatory")
		case .shrine:
			pinImage = #imageLiteral(resourceName: "shrine")
		}
		let size: CGSize = CGSize(width: 30, height: 30)
		UIGraphicsBeginImageContext(size)
		pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		self.image = resizedImage
		self.displayPriority = .required
		self.alpha = 0.3
		self.canShowCallout = true
		self.calloutOffset = CGPoint(x: -5, y: 5)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

enum Category: String {
	case monument = "モニュメント"
	case restaurant = "飲食店"
	case park = "公園"
	case beach = "砂浜"
	case museum = "施設"
	case observatory = "展望台"
	case shrine = "神社仏閣"
}
