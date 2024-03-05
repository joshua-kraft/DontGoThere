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
    if streetNumber.isEmpty && streetName.isEmpty && city.isEmpty && state.isEmpty && zip.isEmpty { // empty addresses are unknown
      return "Unknown"
    } else if streetNumber.isEmpty && streetName.isEmpty { // don't include the new line prior to city if there's no street address
      return "\(city), \(state) \(zip)"
    } else {
      return "\(streetNumber) \(streetName)\n\(city), \(state) \(zip)"
    }
  }

  init(streetNumber: String, streetName: String, city: String, state: String, zip: String) {
    self.streetNumber = streetNumber
    self.streetName = streetName
    self.city = city
    self.state = state
    self.zip = zip
  }
  
  init?(fromPlacemark placemark: MKPlacemark) {
    guard let city = placemark.locality else { return nil }
    guard let state = placemark.administrativeArea else { return nil }
    guard let zip = placemark.postalCode else { return nil }
    self.streetNumber = placemark.subThoroughfare ?? ""
    self.streetName = placemark.thoroughfare ?? ""
    self.city = city
    self.state = state
    self.zip = zip
  }
  
  static let emptyAddress = Address(streetNumber: "", streetName: "", city: "", state: "", zip: "")
}
