//
//  PlacesList.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/15/24.
//

import SwiftData
import SwiftUI

struct PlacesList: View {
  
  @Environment(\.modelContext) var modelContext
  @Query(sort: \Place.name) var places: [Place]
  
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
              Text("Expires: \(place.neverExpires ? "Never" : place.formattedExpirationDate)")
                .font(.footnote)
            }
          }
        }
        .swipeActions() {
          if place.isArchived {
            Button("Delete", systemImage: "trash", role: .destructive) {
              modelContext.delete(place)
            }
            Button("Unarchive", systemImage: "archivebox", role: .destructive) {
              withAnimation {
                place.isArchived.toggle()
              }
            }
            .tint(.green)
          } else {
            Button("Archive", systemImage: "archivebox", role: .destructive) {
              withAnimation {
                place.isArchived.toggle()
              }
            }
            .tint(.orange)
            
            Button("Delete", systemImage: "trash", role: .destructive) {
              modelContext.delete(place)
            }
          }
        }
        .tag(place)
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
  
  init(filteredBy searchString: String = "", sortedBy sortOrder: [SortDescriptor<Place>] = [], archived: Bool = false) {
    _places = Query(filter: #Predicate { place in
      if archived == place.isArchived {
        if searchString.isEmpty {
          return true
        } else {
          return place.name.localizedStandardContains(searchString)
          || place.notes.localizedStandardContains(searchString)
        }
      } else {
        return false
      }
    }, sort: sortOrder)
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PlacesList()
      .modelContainer(previewer.container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
