//
//  GeocodingController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import CoreLocation
import MapKit
import Foundation

struct Geocoder {
  
  static let geocoder = CLGeocoder()
    
  static func getAddressFromCoordinate(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (MKPlacemark) -> ()) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      if error != nil {
        print("error in geocoding")
        return
      }
      
      if let placemarks, let placemark = placemarks.first {
        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        print("error finding placemark")
        return
      }
      
    }
  }
  
  static func getCoordinateFromAddress(address: String, completionHandler: @escaping (MKPlacemark) -> ()) {
    geocoder.geocodeAddressString(address) { placemarks, error in
      if error != nil {
        print("error in geocoding")
        return
      }
      
      if let placemarks, let placemark = placemarks.first {
        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        print("error finding plcemark")
        return
      }
    }
  }

}
