//
//  Venue.swift
//  awjntr
//
//  Created by 松尾大雅 on 2020/12/13.
//  ピンの場所

import MapKit
import AddressBook
import SwiftyJSON

class Venue : NSObject, MKAnnotation {
    
    let name: String?
    let category: String?
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, category: String?, coordinate: CLLocationCoordinate2D)
    {
        self.name = name
        self.category = category
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return category
    }
    
class func from(json: JSON) -> Venue? {
    
    var name: String
    
    if let unWrappedTitle = json["name"].string {
        name = unWrappedTitle
    }else{
        name = ""
    }
    
    let category = json["category"].string
    let lat = json["latitude"].doubleValue
    let long = json["longitude"].doubleValue
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
    return Venue(name: name, category: category, coordinate: coordinate)
    }
    
    }
    
    

