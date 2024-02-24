//
//  PlacesMapView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import MapKit
import SwiftData
import SwiftUI

struct PlacesMapView: View {
    
  @Query var places: [Place]
  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var appSettings: AppSettings
  
  @State private var showExistingPlaces = true
  @State private var path = [Place]()
  
  @State private var isShowingDeleteAlert = false
  @State private var deletedPlace: Place?
    
  @State private var position = MapCameraPosition.automatic
  
  @State private var isShowingSearchSheet = false
  @State private var searchResults = [MapSearchResult]()
  @State private var selectedResult: MapSearchResult?
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        ZStack(alignment: .top) {
          MapReader { proxy in
            Map(position: $position, selection: $selectedResult) {
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
                Marker(coordinate: result.coordinate) {
                  Image(systemName: "mappin")
                }
                .tag(result)
              }
              
            }
            .onChange(of: searchResults) {
              if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedResult = firstResult
              }
            }
            .onChange(of: selectedResult) {
              isShowingSearchSheet = selectedResult == nil
            }
          }
          
          Text("Tap on the map to add a place at that location. Tap and hold on a place to view details or more.")
            .frame(maxWidth: .infinity)
            .padding()
            .font(.subheadline.bold())
            .background(.thinMaterial.opacity(0.8))
            .multilineTextAlignment(.center)
        }
      }
      .navigationTitle("PlaceMap")
      .navigationDestination(for: Place.self) { place in
        EditPlaceView(place: place)
      }
      .sheet(isPresented: $isShowingSearchSheet) {
        PlaceMapSearchView(searchResults: $searchResults)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(showExistingPlaces ? "Hide Existing" : "Show Existing") {
            showExistingPlaces.toggle()
          }
        }
        
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("Search", systemImage: "magnifyingglass") {
            isShowingSearchSheet.toggle()
          }

          Button("Add Place", systemImage: "plus") {
            addPlace()
          }
        }
      }
      .alert("Delete place", isPresented: $isShowingDeleteAlert) {
        Button("Delete", role: .destructive) {
          if let deletedPlace {
            modelContext.delete(deletedPlace)
          }
        }
        Button("Cancel", role: .cancel) { }
      } message: {
        Text("Are you sure?")
      }


    }
  }

  func addPlace(at location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30.5788, longitude: -97.8531)) {
    let newPlace = Place(
      name: "",
      review: "",
      latitude: location.latitude,
      longitude: location.longitude,
      addDate: Date.now,
      expirationDate: appSettings.neverExpire ? Date.distantFuture : appSettings.getExpiryDate(from: Date.now),
      shouldExpire: !appSettings.neverExpire,
      imageData: []
    )
    modelContext.insert(newPlace)
    path.append(newPlace)
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return PlacesMapView()
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
  } catch {
    return Text("Could not create preview: \(error.localizedDescription)")
  }
}
