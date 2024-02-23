//
//  PlaceMapSearchView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import MapKit
import SwiftUI

struct PlaceMapSearchView: View {
  
  
  @State private var locationServiceController = LocationServiceController(completer: .init())
  @State private var searchText = "Bella Sera"
  
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
        TextField("Search for a place...", text: $searchText)
          .autocorrectionDisabled()
      }
      .modifier(SearchBarModifier())
      .onChange(of: searchText) {
        locationServiceController.updateSearchResults(with: searchText)
      }
      
      Spacer()
      
      List {
        ForEach(locationServiceController.searchCompletions) { completion in
          VStack(alignment: .leading, spacing: 4) {
            Text(completion.name)
              .font(.headline)
              .fontDesign(.rounded)
            Text(completion.address)
          }
          .listRowBackground(Color.gray.opacity(0.2))
        }
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
    }
    .padding()
    .onAppear { locationServiceController.updateSearchResults(with: searchText) }
    .presentationDetents([.height(150), .large])
    .presentationBackgroundInteraction(.enabled(upThrough: .large))
  }
}

struct SearchBarModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(12)
      .background(.gray.opacity(0.2))
      .clipShape(.rect(cornerRadius: 8))
      .foregroundStyle(.primary)
  }
}

#Preview {
  PlaceMapSearchView()
}
