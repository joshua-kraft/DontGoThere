//
//  PlacesListView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct PlacesListView: View {
  
  enum PlaceListType: String, CaseIterable {
    case active = "Active", archived = "Archived"
  }
  
  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var appSettings: AppSettings
  
  @State private var path = [Place]()
  @State private var searchText = ""
  @State private var sortOrder = [SortDescriptor(\Place.name)]
  @State private var listType = PlaceListType.active
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack() {
        Picker("Active/Archived", selection: $listType) {
          ForEach(PlaceListType.allCases, id: \.self) { type in
            Text(type.rawValue)
          }
        }
        .pickerStyle(.segmented)
        .padding([.leading, .trailing])
        
        switch listType {
        case .active:
          PlacesList(filteredBy: searchText, sortedBy: sortOrder)
            .searchable(text: $searchText)
        case .archived:
          PlacesList(filteredBy: searchText, sortedBy: sortOrder, archived: true)
            .searchable(text: $searchText)
        }
      }
      .navigationTitle("Your Places")
      .navigationDestination(for: Place.self) { place in
        EditPlaceView(place: place)
      }
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
          
          if listType == .active {
            Button("Add Place", systemImage: "plus", action: addPlace)
          }
        }
      }
    }
  }
  
  func addPlace() {
    let newPlace = Place(name: "", notes: "", review: "", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(appSettings.autoExpiryInterval), imageData: [])
    modelContext.insert(newPlace)
    path.append(newPlace)
  }
  
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return PlacesListView()
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
