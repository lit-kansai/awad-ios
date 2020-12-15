//
//  Venue.swift
//  awjntr
//
//  Created by 松尾大雅 on 2020/12/13.
//  ピンの場所

import MapKit
import AddressBook
import SwiftyJSON

class Venue: NSObject, MKAnnotation {
	
	let coordinate: CLLocationCoordinate2D
	let title: String?
	let subtitle: String?

	
	init(name: String, category: String?, coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
		self.title = name
		self.subtitle = category
		super.init()
	}
	
	class func from(json: JSON) -> Venue? {
		
		var name: String
		
		if let unWrappedTitle: String = json["name"].string {
			name = unWrappedTitle
		} else {
			name = ""
		}
		
		let category: String? = json["category"].string
		let lat: Double = json["latitude"].doubleValue
		let long: Double = json["longitude"].doubleValue
		let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
		
		return Venue(name: name, category: category, coordinate: coordinate)
	}
	
}
