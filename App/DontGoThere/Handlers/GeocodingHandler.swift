//
//  GeocodingHandler.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import CoreLocation
import MapKit
import Foundation

struct GeocodingHandler {
  static let geocoder = CLGeocoder()

  static func getAddressFromCoordinate(coordinate: CLLocationCoordinate2D,
                                       completionHandler: @escaping (MKPlacemark) -> Void) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      if let error {
        print(error.localizedDescription)
        return
      }

      if let placemarks, let placemark = placemarks.first {
        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        // We couldn't find a placemark. We can't do anything.
        return
      }
    }
  }

  static func getCoordinateFromAddress(address: String,
                                       completionHandler: @escaping (MKPlacemark) -> Void) {
    geocoder.geocodeAddressString(address) { placemarks, error in
      if let error {
        print(error.localizedDescription)
        return
      }

      if let placemarks, let placemark = placemarks.first {
        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        // We couldn't find a placemark. We can't do anything. 
        return
      }
    }
  }
}
