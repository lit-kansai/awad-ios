//
//  CompassModel.swift
//  awjntr
//
//  Created by tomoya tanaka on 2020/12/13.
//

import Foundation

protocol CompassModelInput {
	func distance(current: (latitude: Double, longitude: Double), target: (latitude: Double, longitude: Double)) -> Double
	func setupDirection(current: (latitude: Double, longitude: Double), target: (latitude: Double, longitude: Double))
	func calcCheckpointDirection(direction: Double) -> Double
	func calcCheckpointDistance(current: (latitude: Double, longitude: Double), target: (latitude: Double, longitude: Double)) -> Double
}

final class CompassModel: CompassModelInput {
	
	private(set) var originDegree: Double = 0
	private(set) var currentDegree: Double = 0
	
	private func toRadian(_ angle: Double) -> Double {
		return angle * Double.pi / 180
	}
	
	func distance(current: (latitude: Double, longitude: Double), target: (latitude: Double, longitude: Double)) -> Double {
		// 緯度経度をラジアンに変換
		let currentLatitude: Double   = current.latitude * Double.pi / 180
		let currentLongitude: Double   = current.longitude * Double.pi / 180
		let targetLatitude: Double    = target.latitude * Double.pi / 180
		let targetLongitude: Double    = target.longitude * Double.pi / 180
		
		// 赤道半径
		let equatorRadius: Double = 6_378_137.0
		
		// 算出
		let averageLatitude: Double = (currentLatitude - targetLatitude) / 2
		let averageLongitude: Double = (currentLongitude - targetLongitude) / 2
		let distance: Double = equatorRadius * 2 * asin(sqrt(pow(sin(averageLatitude), 2) + cos(currentLatitude) * cos(targetLatitude) * pow(sin(averageLongitude), 2)))
		return distance
	}
	
	func setupDirection(current: (latitude: Double, longitude: Double), target: (latitude: Double, longitude: Double)) {
		let currentLatitude: Double = toRadian(current.latitude)
		let currentLongitude: Double = toRadian(current.longitude)
		let targetLatitude: Double = toRadian(target.latitude)
		let targetLongitude: Double = toRadian(target.longitude)
		let difLongitude: Double = targetLongitude - currentLongitude
		let y: Double = sin(difLongitude)
		let x: Double = cos(currentLatitude) * tan(targetLatitude) - sin(currentLatitude) * cos(difLongitude)
		let p: Double = atan2(y, x) * 180 / Double.pi
		if p < 0 {
			originDegree = Double(360 + atan2(y, x) * 180 / Double.pi)
		} else {
			originDegree = Double(atan2(y, x) * 180 / Double.pi)
		}
	}
	
	func calcCheckpointDirection(direction: Double) -> Double {
		let radian: Double = toRadian((originDegree - Double(direction)) - currentDegree)
		currentDegree = radian
		return radian
	}
	
	func calcCheckpointDistance(current currentLocation: (latitude: Double, longitude: Double), target targetLocation: (latitude: Double, longitude: Double)) -> Double {
		let distance: Double = self.distance(current: currentLocation, target: targetLocation)
		return distance
	}
}
