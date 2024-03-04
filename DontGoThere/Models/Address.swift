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
    "\(streetNumber) \(streetName)\n\(city), \(state) \(zip)"
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

}
