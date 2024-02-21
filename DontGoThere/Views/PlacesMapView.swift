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
  
  let startPosition = MapCameraPosition.region(MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 30.5788, longitude: -97.8531),
    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
  )
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        ZStack(alignment: .top) {
          
          MapReader { proxy in
            Map(initialPosition: startPosition) {
              if showExistingPlaces {
                ForEach(places.filter { !$0.isArchived }) { place in
                  Annotation(place.name, coordinate: place.coordinate) {
                    DontGoThereIconView(width: 50, height: 40)
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
            }
            .onTapGesture { position in
              if let coordinate = proxy.convert(position, from: .local) {
                addPlace(at: coordinate)
              }
            }
          }
          
          Text("Tap on the map to add a place at that location. Tap and hold on a place to view details or more.")
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
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(showExistingPlaces ? "Hide Existing" : "Show Existing") {
            showExistingPlaces.toggle()
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
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
