//
//  PlacesMapView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import MapKit
import SwiftData
import SwiftUI

struct PlacesMapView: View {

  @Query var places: [Place]
  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var settingsHandler: SettingsHandler
  @EnvironmentObject var locationHandler: LocationHandler

  var locationAuthorized: Bool { locationHandler.locationAuthorized }

  @State private var showExistingPlaces = true
  @State private var path = [Place]()

  @State private var isShowingDeleteAlert = false
  @State private var deletedPlace: Place?

  @State private var isShowingSearchSheet = false
  @State private var searchResults = [MapSearchResult]()

  @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
  @State private var visibleRegion: MKCoordinateRegion?
  @Namespace var mapScope

  let notSearchingOverlayText =
  "Tap on the map to add a place at that location. "
  + "Tap and hold on a place to view details or delete."

  let searchingOverlayText =
  "Tap on a seach result or marker to add a place at that location. "
  + "End searching to show your current places."

  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        MapReader { proxy in
          ZStack(alignment: .bottomTrailing) {
            Map(position: $position, scope: mapScope) {

              if locationAuthorized {
                UserAnnotation()
              }

              if showExistingPlaces {
                ForEach(places.filter { !$0.isArchived }) { place in
                  Annotation(place.name, coordinate: place.coordinate) {
                    DontGoThereIconView(width: 40, height: 32)
                      .contextMenu {
                        Button("Show Details", systemImage: "list.dash") { path.append(place) }
                        Button("Delete", systemImage: "trash", role: .destructive) {
                          deletedPlace = place
                          isShowingDeleteAlert = true
                        }
                      }
                  }
                }
              }

              ForEach(searchResults) { result in
                Annotation(result.name, coordinate: result.coordinate) {
                  DontGoThereSearchIconView(width: 40, height: 40)
                    .tag(result)
                    .onTapGesture {
                      withAnimation {
                        isShowingSearchSheet = false
                      }
                      addPlace(at: result.coordinate, with: result)
                    }
                }
              }
            }
            .onTapGesture { position in
              if let tappedCoordinate = proxy.convert(position, from: .local) {
                if searchResults.isEmpty {
                  addPlace(at: tappedCoordinate)
                }
              }
            }
            .safeAreaInset(edge: .top) {
              Text(isShowingSearchSheet ? searchingOverlayText : notSearchingOverlayText)
                .frame(maxWidth: .infinity)
                .padding()
                .font(.subheadline.bold())
                .background(.thinMaterial.opacity(0.8))
                .multilineTextAlignment(.center)
            }

            if locationAuthorized {
              VStack {
                Button {
                  withAnimation {
                    position = .automatic
                  }
                } label: {
                  DontGoThereMapButtonLabel()
                }
                MapUserLocationButton(scope: mapScope)
              }
              .padding([.bottom, .trailing], 10)
              .buttonBorderShape(.circle)
            }
          }
          .mapScope(mapScope)
        }
      }
      .navigationTitle("PlaceMap")
      .navigationDestination(for: Place.self) { place in
        EditPlaceView(place: place)
      }
      .onChange(of: searchResults) {
        withAnimation {
          position = .automatic
        }
      }
      .onMapCameraChange { context in
        visibleRegion = context.region
      }
      .sheet(isPresented: $isShowingSearchSheet, onDismiss: {
        searchResults = []
      }, content: {
        PlaceMapSearchView(searchResults: $searchResults, visibleRegion: $visibleRegion)
      })
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(showExistingPlaces ? "Hide Existing" : "Show Existing") {
            withAnimation {
              showExistingPlaces.toggle()
            }
          }
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("Search", systemImage: "magnifyingglass") {
            withAnimation {
              isShowingSearchSheet.toggle()
            }
          }
          .onChange(of: isShowingSearchSheet) {
            withAnimation {
              showExistingPlaces = !isShowingSearchSheet
            }
          }

          if locationAuthorized {
            Button("Add Place", systemImage: "plus") {
              addPlace(forCurrentLocation: true, at: locationHandler.lastLocation.coordinate)
            }
          }
        }
      }
      .alert("Delete Place", isPresented: $isShowingDeleteAlert) {
        Button("Delete", role: .destructive) {
          if let deletedPlace {
            Task { await locationHandler.removeConditionFromMonitor(id: deletedPlace.id.uuidString) }
            modelContext.delete(deletedPlace)
          }
        }
        Button("Cancel", role: .cancel) { }
      } message: {
        Text("Are you sure?")
      }
    }
  }

  func addPlace(forCurrentLocation: Bool = false,
                at coordinate: CLLocationCoordinate2D? = nil,
                with result: MapSearchResult? = nil) {
    if let coordinate {
      let newPlace = Place(
        name: result?.name ?? "",
        review: "",
        latitude: coordinate.latitude,
        longitude: coordinate.longitude,
        radius: settingsHandler.regionRadius,
        address: Address.emptyAddress,
        shouldExpire: !settingsHandler.neverExpire,
        maxNotificationCount: settingsHandler.maxNotificationCount,
        addDate: Date.now,
        expirationDate: settingsHandler.neverExpire ? Date.distantFuture : settingsHandler.getExpiryDate(from: .now),
        imageData: []
      )
      modelContext.insert(newPlace)
      path.append(newPlace)

      GeocodingHandler.getAddressFromCoordinate(coordinate: coordinate) { placemark in
        if let address = Address(fromPlacemark: placemark) {
          newPlace.address = address
        }
      }

      Task { await locationHandler.addConditionToMonitor(condition: newPlace.region, id: newPlace.id.uuidString) }
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PlacesMapView()
      .modelContainer(previewer.container)
      .environmentObject(SettingsHandler.defaults)
      .environmentObject(LocationHandler.shared)
  } catch {
    return Text("Could not create preview: \(error.localizedDescription)")
  }
}
