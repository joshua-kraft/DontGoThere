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
  @EnvironmentObject var locationHandler: LocationHandler

  @State private var path = [Place]()
  @State private var searchText = ""
  @State private var sortOrder = [SortDescriptor(\Place.name)]
  @State private var listType = PlaceListType.active

  @Query private var places: [Place]

  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        if places.isEmpty {
          ContentUnavailableView {
            DontGoThereUnavailableLabel("No Places Added")
          } description: {
            Text(emptyDescriptionText())
          } actions: {
            if locationHandler.locationAuthorized {
              Button("Add First Place", action: addPlace)
            }
          }
        } else {
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
      }
      .navigationTitle("Your Places")
      .navigationDestination(for: Place.self) { place in
        EditPlaceView(place: place)
      }
      .toolbar {

        if !places.isEmpty {
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
              if locationHandler.locationAuthorized {
                Button("Add Place", systemImage: "plus", action: addPlace)
              }
            }
          }
        }
      }
    }
  }

  func emptyDescriptionText() -> String {
    "You haven't added any places yet." +
    (locationHandler.locationAuthorized ? "" : "Go to the PlaceMap to add your first Place.")
  }

  func addPlace() {
    let newPlace = Place(
      name: "",
      review: "",
      latitude: locationHandler.lastLocation.coordinate.latitude,
      longitude: locationHandler.lastLocation.coordinate.longitude,
      radius: appSettings.regionRadius,
      address: Address.emptyAddress,
      shouldExpire: !appSettings.neverExpire,
      maxNotificationCount: appSettings.maxNotificationCount,
      addDate: Date.now,
      expirationDate: appSettings.neverExpire ? Date.distantFuture : appSettings.getExpiryDate(from: Date.now),
      imageData: []
    )
    modelContext.insert(newPlace)
    path.append(newPlace)

    GeocodingHandler.getAddressFromCoordinate(coordinate: locationHandler.lastLocation.coordinate) { placemark in
      if let address = Address(fromPlacemark: placemark) {
        newPlace.address = address
      }
    }

    Task { await locationHandler.addConditionToMonitor(condition: newPlace.region, id: newPlace.id.uuidString) }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PlacesListView()
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
      .environmentObject(LocationHandler.shared)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
