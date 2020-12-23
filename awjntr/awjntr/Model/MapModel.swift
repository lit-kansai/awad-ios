//
//  MapModel.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/15.
//

import Foundation
import MapKit

protocol MapModelInput {
	func generateAdditions() -> MapAddition
}

final class MapModel: MapModelInput {
	
	func generateAdditions() -> MapAddition {
		var annotations: [CheckpointAnnotation] = []
		var overlays: [MKOverlay] = []
		
		guard let url = Bundle.main.url(forResource: "location", withExtension: "json") else {
			fatalError("File not found")
		}
		
		guard let data = try? Data(contentsOf: url) else {
			fatalError("File load error")
		}
		
		do {
			let locations: [Checkpoint] = try JSONDecoder().decode([Checkpoint].self, from: data)
			for location in locations {
				let annotation: CheckpointAnnotation = CheckpointAnnotation(title: location.name, subtitle: location.category, latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
				annotations.append(annotation)
				
				let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(location.latitude)!, Double(location.longitude)!)
				let circle: MKCircle = MKCircle(center: location, radius: CLLocationDistance(500))
				overlays.append(circle)
			}
		} catch let error {
			print(error)
		}
		return MapAddition(annotations: annotations, circles: overlays)
	}
}

struct Checkpoint: Codable {
	var name: String
	var category: String
	var longitude: String
	var latitude: String
}

struct MapAddition {
	var annotations: [CheckpointAnnotation]
	var circles: [MKOverlay]
}
