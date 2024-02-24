//
//  LocationServiceController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import MapKit
import SwiftUI

struct MapSearchCompletion: Identifiable {
  let id = UUID()
  let name: String
  let address: String
}

struct MapSearchResult: Identifiable, Hashable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
  
  static func ==(lhs: MapSearchResult, rhs: MapSearchResult) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}


@Observable
class LocationServiceController: NSObject, MKLocalSearchCompleterDelegate {
  let completer: MKLocalSearchCompleter
  
  var searchCompletions = [MapSearchCompletion]()
  
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
      MapSearchCompletion(name: $0.title, address: $0.subtitle)
    }
  }
  
  func performSearch(with searchText: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [MapSearchResult] {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = searchText
    searchRequest.resultTypes = .pointOfInterest
    if let coordinate {
      searchRequest.region = MKCoordinateRegion(
        center: coordinate,
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
      )
    }
    let search = MKLocalSearch(request: searchRequest)
    
    let response = try await search.start()
    
    return response.mapItems.compactMap { mapItem in
      guard let coordinate = mapItem.placemark.location?.coordinate else { return nil }
      
      return MapSearchResult(coordinate: coordinate)
    }
  }
  
}


