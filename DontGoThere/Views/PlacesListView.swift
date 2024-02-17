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
  @State private var sortOrder = [SortDescriptor(\Place.name)]
  
  var body: some View {
    NavigationStack(path: $path) {
      SortableListView(filteredBy: searchText, sortedBy: sortOrder)
        .navigationTitle("Your Places")
        .navigationDestination(for: Place.self) { place in
          EditPlaceView(place: place)
        }
        .searchable(text: $searchText)
        .toolbar {
          ToolbarItemGroup(placement: .topBarLeading) {
            EditButton()
          }
          
          ToolbarItemGroup(placement: .topBarTrailing) {
            Menu("Sort Places", systemImage: "arrow.up.arrow.down") {
              Picker("Sort", selection: $sortOrder) {
                Text("Name (A - Z)")
                  .tag([SortDescriptor(\Place.name)])
                
                Text("Name (Z - A)")
                  .tag([SortDescriptor(\Place.name, order: .reverse)])
                
                Text("Date Added (New - Old)")
                  .tag([SortDescriptor(\Place.addDate, order: .reverse)])
                
                Text("Date Added (Old - New)")
                  .tag([SortDescriptor(\Place.addDate)])
                
                Text("Expiry Date (Sooner - Later)")
                  .tag([SortDescriptor(\Place.expirationDate)])
                
                Text("Expiry Date (Later - Sooner)")
                  .tag([SortDescriptor(\Place.expirationDate, order: .reverse)])
              }
            }
            
            Button("Add Place", systemImage: "plus", action: addPlace)
          }
        }
    }
  }
  
  func addPlace() {
    let newPlace = Place(name: "", notes: "", review: "", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now, imageData: [])
    modelContext.insert(newPlace)
    path.append(newPlace)
  }
  
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return PlacesListView()
      .modelContainer(previewer.container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
