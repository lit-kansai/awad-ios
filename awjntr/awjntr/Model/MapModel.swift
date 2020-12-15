//
//  MapModel.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/15.
//

import Foundation
import MapKit

protocol MapModelInput {
	func generateAnnotations() -> [CheckpointAnnotation]
}

final class MapModel: MapModelInput {
	func generateAnnotations() -> [CheckpointAnnotation] {
		var annotations: [CheckpointAnnotation] = []
		
		guard let url = Bundle.main.url(forResource: "checkpoints", withExtension: "json") else {
			fatalError("File not found")
		}
		
		guard let data = try? Data(contentsOf: url) else {
			fatalError("File load error")
		}
		
		do {
			let locations: [Checkpoint] = try JSONDecoder().decode([Checkpoint].self, from: data)
			for location in locations {
				let annotation: CheckpointAnnotation = CheckpointAnnotation(name: location.name, category: location.category, latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
			
				annotations.append(annotation)
			}
		} catch let error {
			print(error)
		}
		return annotations
	}
}

final class CheckpointAnnotation: NSObject, MKAnnotation {
	let coordinate: CLLocationCoordinate2D
	let title: String?
	let subtitle: String?

	init(name: String, category: String?, latitude: Double, longitude: Double) {
		let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		self.coordinate = coordinate
		self.title = name
		self.subtitle = category
		super.init()
	}
}

struct Checkpoint: Codable {
	var name: String
	var category: String
	var longitude: String
	var latitude: String
}
