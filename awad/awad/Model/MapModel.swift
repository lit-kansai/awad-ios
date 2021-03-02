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
	
	// Annotationと緑の○を生成
	func generateAdditions() -> MapAddition {
		var annotations: [Checkpoint] = []
		var overlays: [MKOverlay] = []
		
		guard let checkPointUrl = Bundle.main.url(forResource: "location", withExtension: "json") else {
			fatalError("File not found")
		}
		
		guard let checkPointData = try? Data(contentsOf: checkPointUrl) else {
			fatalError("File load error")
		}
		
		do {
			let locations: [CheckpointCodable] = try JSONDecoder().decode([CheckpointCodable].self, from: checkPointData)
			for location in locations {
				// NOTE: titleとsubtitleを別のやつに変える
				let annotation: Checkpoint = Checkpoint(title: location.name, subtitle: location.category, latitude: Double(location.latitude)!, longitude: Double(location.longitude)!, mission: location.mission, checkpointName: location.name, checkpointCategory: location.category, checkpointDescription: location.description, stampName: location.stampName, stampImageName: location.stampImageName)
				annotations.append(annotation)
			}
		} catch let error {
			print(error)
		}
		
		guard let randomCheckPointCircleUrl = Bundle.main.url(forResource: "randomCircleLocation", withExtension: "json") else {
			fatalError("File not found")
		}
		
		guard let randomCheckPointCircleData = try? Data(contentsOf: randomCheckPointCircleUrl) else {
			fatalError("File load error")
		}
		
		do {
			let locations: [RandomCheckpointCircle] = try JSONDecoder().decode([RandomCheckpointCircle].self, from: randomCheckPointCircleData)
			for location in locations {
				let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(location.latitude)!, Double(location.longitude)!)
				let circle: MKCircle = MKCircle(center: location, radius: CLLocationDistance(150))
				
				overlays.append(circle)
			}
		} catch let error {
			print(error)
		}
		
		return MapAddition(annotations: annotations, circles: overlays)
	}
}

struct CheckpointCodable: Codable {
	var name: String
	var category: String
	var longitude: String
	var latitude: String
	var mission: String
	var description: String
	var stampName: String
	var stampImageName: String
}

struct RandomCheckpointCircle: Codable {
	var latitude: String
	var longitude: String
}

struct MapAddition {
	var annotations: [Checkpoint]
	var circles: [MKOverlay]
}
