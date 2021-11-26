//
//  LocationMath.swift
//  Polse
//
//  Created by abbas on 2/21/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
import CoreLocation

class LocationMath:NSObject {
    fileprivate static func deg2rad(_ deg:Double) -> Double {
        return deg * Double.pi / 180
    }

    fileprivate static func rad2deg(_ rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }

    static func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String = "K") -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta))
        dist = acos(dist)
        dist = rad2deg(dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
}
extension LocationMath:CLLocationManagerDelegate {
    
}
