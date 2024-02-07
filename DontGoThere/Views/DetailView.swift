//
//  DetailView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import MapKit
import SwiftData
import SwiftUI

struct DetailView: View {
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  
  let place: Place

  var body: some View {
    NavigationStack {
      VStack {
        Map(initialPosition: position(for: place), interactionModes: []) {
          Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
        }
        .frame(width: .infinity, height: 200)
        
        Form {
          Section("Details") {
            HStack {
              Text("Name:")
                .font(.headline)
                .foregroundStyle(.secondary)
              TextField("", text: .constant(place.name))
            }
            HStack {
              Text("Notes:")
                .font(.headline)
                .foregroundStyle(.secondary)
              TextField("", text: .constant(place.notes))
            }
            HStack(alignment: .top) {
              Text("Review:")
                .font(.headline)
                .foregroundStyle(.secondary)
              TextField("", text: .constant(place.review), axis: .vertical)
            }
            HStack {
              Text("Added:")
                .font(.headline)
                .foregroundStyle(.secondary)
              Text(place.formattedAddDate)
            }
            HStack {
              Text("Expires:")
                .font(.headline)
                .foregroundStyle(.secondary)
              Text(place.formattedExpirationDate)
            }
          }
        }
    
      }
      .navigationTitle(place.name)
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  func position(for place: Place) -> MapCameraPosition {
    MapCameraPosition.region(
    MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude),
      span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    )
  }
}

#Preview {
  do {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Place.self, configurations: config)
    let examplePlace = Place(name: "Example Place Name", notes: "Example Notes Text", review: "This is a longer sentence that is being used as the preview review for this example place in order to wrap the TextField inside the preview.", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(7 * 86400), imageNames: ["example1a", "example1b", "example1c"])
    
    return DetailView(place: examplePlace)
      .modelContainer(container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
