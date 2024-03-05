//
//  MapSearchController.swift
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
  let name: String
  
  static func ==(lhs: MapSearchResult, rhs: MapSearchResult) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}


@Observable
class MapSearchController: NSObject, MKLocalSearchCompleterDelegate {
  let completer: MKLocalSearchCompleter
  var searchCompletions = [MapSearchCompletion]()
  
  init(completer: MKLocalSearchCompleter) {
    self.completer = completer
    super.init()
    self.completer.delegate = self
  }
  
  func updateSearchResults(with queryFragment: String, in region: MKCoordinateRegion? = nil) {
    completer.resultTypes = .pointOfInterest
    if let region {
      completer.region = region
    }
    completer.queryFragment = queryFragment
  }
  
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchCompletions = completer.results.map {
      MapSearchCompletion(name: $0.title, address: $0.subtitle)
    }
  }
    
  func performSearch(with searchText: String, in region: MKCoordinateRegion? = nil) async throws -> [MapSearchResult] {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = searchText
    searchRequest.resultTypes = .pointOfInterest
    if let region {
      searchRequest.region = region
    }
    let search = MKLocalSearch(request: searchRequest)
    
    let response = try await search.start()
    
    return response.mapItems.compactMap { mapItem in
      guard let coordinate = mapItem.placemark.location?.coordinate else { return nil }
      guard let name = mapItem.name else { return nil }
      return MapSearchResult(coordinate: coordinate, name: name)
    }
  }
  
  
  
}


