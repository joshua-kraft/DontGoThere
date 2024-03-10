//
//  PlaceMinimapView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

struct PlaceMinimapView: View {

  @Bindable var place: Place
  @State var position: MapCameraPosition = .automatic

  var body: some View {
    MapReader { mapProxy in
      Map(position: $position, interactionModes: [.pan, .zoom, .rotate]) {
        Marker(place.name, coordinate: place.coordinate)
      }
      .frame(height: 250)
      .onChange(of: place.coordinate) {
        position = .automatic
      }
      .onTapGesture { position in
        if let tappedCoordinate = mapProxy.convert(position, from: .local) {
          updatePosition(with: tappedCoordinate)
        }
      }
      .safeAreaInset(edge: .top) {
        Text("Tap on the map to edit this place's location.")
          .frame(maxWidth: .infinity)
          .padding([.top, .bottom], 12)
          .font(.subheadline.bold())
          .background(.thinMaterial.opacity(0.9))
          .multilineTextAlignment(.center)
      }
    }
  }

  func updatePosition(with tappedCoordinate: CLLocationCoordinate2D) {
    place.latitude = tappedCoordinate.latitude
    place.longitude = tappedCoordinate.longitude
    GeocodingHandler.getAddressFromCoordinate(coordinate: tappedCoordinate) { placemark in
      if let address = Address(fromPlacemark: placemark) {
        place.address = address
      }
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return PlaceMinimapView(place: previewer.activePlace)
      .modelContainer(previewer.container)
      .environmentObject(LocationHandler.shared)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
