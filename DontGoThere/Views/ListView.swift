//
//  ListView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct ListView: View {
  
  @Query(sort: \Place.name) var places: [Place]
  @Environment(\.modelContext) var modelContext
    
  var body: some View {
    NavigationStack {
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
      .navigationTitle("DontGoThere")
      .navigationDestination(for: Place.self) { place in
        DetailView(place: place)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Add Place", systemImage: "plus") {
            
          }
        }
      }
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
  ListView()
    .modelContainer(Place.listPreview)
}
