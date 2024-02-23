//
//  LocationServiceController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import MapKit
import SwiftUI

struct MapSearchResults: Identifiable {
  let id = UUID()
  let name: String
  let address: String
  let mapItem: MKMapItem?
}

@Observable
class LocationServiceController: NSObject, MKLocalSearchCompleterDelegate {
  let completer: MKLocalSearchCompleter
  
  var searchCompletions = [MapSearchResults]()
  
  init(completer: MKLocalSearchCompleter) {
    self.completer = completer
    super.init()
    self.completer.delegate = self
  }
  
  func updateSearchResults(with queryFragment: String) {
    completer.resultTypes = .pointOfInterest
    completer.queryFragment = queryFragment
  }
  
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchCompletions = completer.results.map {
      let mapItem = $0.value(forKey: "_mapItem") as? MKMapItem
      return MapSearchResults(name: $0.title, address: $0.subtitle, mapItem: mapItem)
    }
  }
}


