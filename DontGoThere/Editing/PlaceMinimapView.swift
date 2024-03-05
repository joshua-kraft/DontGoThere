//
//  PlaceMinimapView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import SwiftUI
import MapKit

struct PlaceMinimapView: View {
  
  @Bindable var place: Place
  
  var body: some View {
    ZStack(alignment: .top) {
      MapReader { mapProxy in
        Map(initialPosition: position(for: place), interactionModes: [.pan, .zoom, .rotate]) {
          Marker(place.name, coordinate: place.coordinate)
        }
        .frame(height: 250)
        .onTapGesture { position in
          if let tappedCoordinate = mapProxy.convert(position, from: .local) {
            place.latitude = tappedCoordinate.latitude
            place.longitude = tappedCoordinate.longitude
            Address.getAddressFromCoordinate(coordinate: tappedCoordinate) { placemark in
              if let address = Address(fromPlacemark: placemark) {
                place.address = address
              }
            }
          }
        }
      }
      
      Text("Tap on the map to edit this place's location.")
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 12)
        .font(.subheadline.bold())
        .background(.thinMaterial.opacity(0.9))
        .multilineTextAlignment(.center)
    }
  }
  
  func position(for place: Place) -> MapCameraPosition {
    MapCameraPosition.region(
      MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
    )
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return PlaceMinimapView(place: previewer.activePlace)
      .modelContainer(previewer.container)
    
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
