//
//  SortableListView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/15/24.
//

import SwiftData
import SwiftUI

struct SortableListView: View {
  
  @Environment(\.modelContext) var modelContext
  @Query(sort: \Place.name) var places: [Place]
  
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
  }
  
  func deletePlaces(at offsets: IndexSet) {
    for offset in offsets {
      let place = places[offset]
      modelContext.delete(place)
    }
  }
}

#Preview {
  SortableListView()
    .modelContainer(Place.previewPlaces)
}
