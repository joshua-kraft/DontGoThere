//
//  PlaceMapSearchView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import MapKit
import SwiftUI

struct PlaceMapSearchView: View {

  @State private var mapSearchHandler = MapSearchHandler(completer: .init())
  @State private var searchText = ""
  @FocusState private var isSearchFieldFocused: Bool
  @State private var presentationDetent: PresentationDetent = .fraction(0.20)
  @Binding var searchResults: [MapSearchResult]
  @Binding var visibleRegion: MKCoordinateRegion?

  var body: some View {
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
        TextField("Search for a place...", text: $searchText)
          .focused($isSearchFieldFocused)
          .onSubmit {
            if mapSearchHandler.searchCompletions.isEmpty == false {
              Task {
                let results = (try? await mapSearchHandler.performSearch(with: searchText, in: visibleRegion)) ?? []
                withAnimation {
                  searchResults = results
                }
              }
            }
          }
      }
      .modifier(SearchBarModifier())
      .onChange(of: searchText) {
        mapSearchHandler.updateSearchResults(with: searchText, in: visibleRegion)
      }
      .padding(.bottom)

      List {
        ForEach(mapSearchHandler.searchCompletions) { completion in
          VStack(alignment: .leading) {
            Text(completion.name)
              .font(.headline)
              .fontDesign(.rounded)
            Text(completion.address)
          }
          .listRowBackground(Color.gray.opacity(0.2))
          .onTapGesture {
            rowTapped(completion: completion)
            presentationDetent = .fraction(0.20)
          }
        }
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
    }
    .padding()
    .presentationDetents([.fraction(0.20), .large], selection: $presentationDetent)
    .presentationBackgroundInteraction(.enabled(upThrough: .large))
    .onAppear {
      isSearchFieldFocused = true
    }
    .scrollDismissesKeyboard(.interactively)
  }

  func rowTapped(completion: MapSearchCompletion) {
    Task {
      if let tappedResult = try? await mapSearchHandler.performSearch(
        with: "\(completion.name) \(completion.address)",
        in: visibleRegion).first {
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
  PlaceMapSearchView(searchResults: .constant([]), visibleRegion: .constant(MKCoordinateRegion()))
}
