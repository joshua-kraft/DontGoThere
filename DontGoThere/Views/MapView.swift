//
//  MapView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import MapKit
import SwiftData
import SwiftUI

struct MapView: View {
  
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
  
  let startPosition = MapCameraPosition.region(MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 30.5788, longitude: -97.8531),
    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
  )
  
  var body: some View {
    NavigationStack(path: $path) {
      MapReader { proxy in
        Map(initialPosition: startPosition) {
          if showExistingPlaces {
            ForEach(places) { place in
              Annotation(place.name, coordinate: place.coordinate) {
                DontGoThereAnnotation()
                  .onLongPressGesture {
                    path.append(place)
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
        .navigationTitle("DontGoThere")
        .navigationDestination(for: Place.self) { place in
          DetailView(place: place)
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
      }
    }
  }
  
  func addPlace(at location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30.5788, longitude: -97.8531)) {
    let place = Place(name: "", notes: "", review: "", latitude: location.latitude, longitude: location.longitude, addDate: Date.now, expirationDate: Date.now)
    modelContext.insert(place)
    path.append(place)
  }
}

#Preview {
  MapView()
    .modelContainer(Place.listPreview)
}
