//
//  Address.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/4/24.
//

import Foundation
import MapKit

struct Address: Codable {
  let streetNumber: String
  let streetName: String
  let city: String
  let state: String
  let zip: String
  var printableAddress: String {
    (streetNumber.isEmpty && streetName.isEmpty && city.isEmpty && state.isEmpty && zip.isEmpty) ? "Unknown" : "\(streetNumber) \(streetName)\n\(city), \(state) \(zip)"
  }

  init(streetNumber: String, streetName: String, city: String, state: String, zip: String) {
    self.streetNumber = streetNumber
    self.streetName = streetName
    self.city = city
    self.state = state
    self.zip = zip
  }
  
  init?(fromPlacemark placemark: MKPlacemark) {
    guard let streetNumber = placemark.subThoroughfare else { return nil }
    guard let streetName = placemark.thoroughfare else { return nil }
    guard let city = placemark.locality else { return nil }
    guard let state = placemark.administrativeArea else { return nil }
    guard let zip = placemark.postalCode else { return nil }
    self.streetNumber = streetNumber
    self.streetName = streetName
    self.city = city
    self.state = state
    self.zip = zip
  }
  
  static let emptyAddress = Address(streetNumber: "", streetName: "", city: "", state: "", zip: "")
  
  static func getAddressFromCoordinate(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (MKPlacemark) -> ()) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      if error != nil {
        print("error in geocoding")
        return
      }
      
      if let placemarks, let placemark = placemarks.first {
        guard let _ = placemark.subThoroughfare else { return }
        guard let _ = placemark.thoroughfare else { return }
        guard let _ = placemark.locality else { return }
        guard let _ = placemark.administrativeArea else { return }
        guard let _ = placemark.postalCode else { return }

        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        print("error finding placemark")
        return
      }
      
    }
  }

}
