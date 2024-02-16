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
  
  struct DontGoThereAnnotation: View {
    
    struct InvertedTriangle: Shape {
      func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
      }
    }
    
    var body: some View {
      ZStack(alignment: .top) {
        InvertedTriangle()
          .stroke(.black, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
          .fill(.yellow)
          .frame(width: 54, height: 44)
        
        Image(systemName: "mappin.slash.circle")
          .resizable()
          .background(.white)
          .foregroundStyle(.black)
          .frame(width: 25, height: 30)
          .clipShape(.circle)
          .padding(.top, 2)
      }
    }
  }
  
  @Query var places: [Place]
  @Environment(\.modelContext) var modelContext
    
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
        MapReader { proxy in
          Map(initialPosition: startPosition) {
            if showExistingPlaces {
              ForEach(places) { place in
                Annotation(place.name, coordinate: place.coordinate) {
                  DontGoThereAnnotation()
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
    }
  }

  func addPlace(at location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30.5788, longitude: -97.8531)) {
    let newPlace = Place(name: "", notes: "", review: "", latitude: location.latitude, longitude: location.longitude, addDate: Date.now, expirationDate: Date.now)
    modelContext.insert(newPlace)
    path.append(newPlace)
  }
}

#Preview {
  PlacesMapView()
    .modelContainer(Place.listPreview)
}
