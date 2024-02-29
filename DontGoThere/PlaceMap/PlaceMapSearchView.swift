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
  @State private var searchText = ""
  @FocusState private var isSearchFieldFocused: Bool
  @Binding var searchResults: [MapSearchResult]
  
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
        TextField("Search for a place...", text: $searchText)
          .focused($isSearchFieldFocused)
          .autocorrectionDisabled()
          .onSubmit {
            Task {
              searchResults = (try? await locationServiceController.performSearch(with: searchText)) ?? []
            }
          }
      }
      .modifier(SearchBarModifier())
      .onChange(of: searchText) {
        locationServiceController.updateSearchResults(with: searchText)
      }
      .padding(.bottom)
      
      
      List {
        ForEach(locationServiceController.searchCompletions) { completion in
          VStack(alignment: .leading) {
            Text(completion.name)
              .font(.headline)
              .fontDesign(.rounded)
            Text(completion.address)
          }
          .listRowBackground(Color.gray.opacity(0.2))
          .onTapGesture { rowTapped(completion: completion) }
        }
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
    }
    .padding()
    .presentationDetents([.fraction(0.25), .large])
    .presentationBackgroundInteraction(.enabled(upThrough: .large))
    .onAppear {
      isSearchFieldFocused = true
    }
    .scrollDismissesKeyboard(.interactively)
  }
  
  func rowTapped(completion: MapSearchCompletion) {
    Task {
      if let tappedResult = try? await locationServiceController.performSearch(with: "\(completion.name) \(completion.address)").first {
        searchResults = [tappedResult]
      }
    }
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
  PlaceMapSearchView(searchResults: .constant([]))
}
