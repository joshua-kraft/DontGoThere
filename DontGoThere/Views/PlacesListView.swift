//
//  PlacesListView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct PlacesListView: View {
  
  @Query(sort: \Place.name) var places: [Place]
  @Environment(\.modelContext) var modelContext
  
  @State private var path = [Place]()
    
  init(filteredBy searchString: String = "") {
    _places = Query(filter: #Predicate { place in
      if searchString.isEmpty {
        return true
      } else {
        return place.name.localizedStandardContains(searchString)
        || place.notes.localizedStandardContains(searchString)
      }
    })
  }
  
  var body: some View {
    NavigationStack(path: $path) {
      List {
        ForEach(places) { place in
          NavigationLink(value: place) {
            HStack {
              VStack(alignment: .leading) {
                Text(place.name)
                  .font(.headline)
                Text(place.notes)
                  .font(.subheadline)
              }
              
              Spacer()
              
              VStack(alignment: .trailing) {
                Text("Added: \(place.formattedAddDate)")
                  .font(.footnote)
                Text("Expires: \(place.formattedExpirationDate)")
                  .font(.footnote)
              }
            }
          }
        }
        .onDelete(perform: deletePlaces)
      }
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
    }
  }
  
  func addPlace() {
    let newPlace = Place(name: "", notes: "", review: "", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now)
    modelContext.insert(newPlace)
    path.append(newPlace)
  }
  
  func deletePlaces(at offsets: IndexSet) {
    for offset in offsets {
      let place = places[offset]
      modelContext.delete(place)
    }
  }
  
}

#Preview {
  PlacesListView()
    .modelContainer(Place.listPreview)
}
