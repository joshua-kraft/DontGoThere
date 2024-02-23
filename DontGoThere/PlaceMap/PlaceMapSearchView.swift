//
//  PlaceMapSearchView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import MapKit
import SwiftUI

struct PlaceMapSearchView: View {
  
  struct SearchResultRow: View {
    
    let result: MKMapItem
    
    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          Text(result.name ?? "Unknown Name")
          Text(result.phoneNumber ?? "Unknown Number")
        }
      }
      
    }
    
    init(_ result: MKMapItem) {
      self.result = result
    }
  }
  
  @State private var searchText = "Bella Sera"
  @Binding var position: MapCameraPosition
  
  @State private var searchResults = [MKMapItem]()
  
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
        TextField("Search for a place...", text: $searchText)
          .autocorrectionDisabled()
          .padding(12)
          .background(.gray.opacity(0.2))
          .clipShape(.rect(cornerRadius: 8))
          .foregroundStyle(.primary)
          .onChange(of: searchText) {
            performSearch()
          }
      }
      
      List(searchResults, id: \.self) { result in
        SearchResultRow(result)
      }
      
    }
    .padding()
    .presentationDetents([.height(150), .large])
    .presentationBackgroundInteraction(.enabled(upThrough: .large))
    .onAppear { performSearch() }
  }
  
  func performSearch() {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = searchText
    if let region = position.region {
      searchRequest.region = region
    }
    let search = MKLocalSearch(request: searchRequest)
    
    search.start { searchResponse, error in
      guard let searchResponse = searchResponse else {
        print("Search failed: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      withAnimation {
        searchResults = searchResponse.mapItems
      }
    }
  }
}

#Preview {
  PlaceMapSearchView(position: .constant(.automatic))
}
