//
//  PlacesListView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct PlacesListView: View {
  
  @Environment(\.modelContext) var modelContext
  
  @State private var path = [Place]()
  @State private var searchText = ""
  
  var body: some View {
    NavigationStack(path: $path) {
      SearchableSortableListView(filteredBy: searchText)
        .navigationTitle("Your Places")
        .navigationDestination(for: Place.self) { place in
          EditPlaceView(place: place)
        }
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            EditButton()
          }
          ToolbarItem(placement: .topBarTrailing) {
            Button("Add Place", systemImage: "plus", action: addPlace)
          }
        }
        .searchable(text: $searchText)
    }
  }
  
  func addPlace() {
    let newPlace = Place(name: "", notes: "", review: "", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now)
    modelContext.insert(newPlace)
    path.append(newPlace)
  }
  
}

#Preview {
  PlacesListView()
    .modelContainer(Place.listPreview)
}
