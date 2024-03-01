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
      
  @State private var isShowingSearchSheet = false
  @State private var searchResults = [MapSearchResult]()
  
  @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
  
  let notSearchingOverlayText = "Tap on the map to add a place at that location. Tap and hold on a place to view details, share, or delete."
  let searchingOverlayText = "Tap on a seach result or marker to add a place at that location. End searching to show your current places."
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        ZStack(alignment: .top) {
          MapReader { proxy in
            Map(position: $position) {
                            
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
                Annotation("Name", coordinate: result.coordinate) {
                  DontGoThereSearchIconView(width: 50, height: 50)
                    .tag(result)
                    .onTapGesture {
                      withAnimation {
                        isShowingSearchSheet = false
                      }
                      addPlace(at: result.coordinate)
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
      }
      .navigationTitle("PlaceMap")
      .navigationDestination(for: Place.self) { place in
        EditPlaceView(place: place)
      }
      .sheet(isPresented: $isShowingSearchSheet, onDismiss: {
        searchResults = []
      }, content: {
        PlaceMapSearchView(searchResults: $searchResults)
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
