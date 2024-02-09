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
  
  struct TextLabel: View {
    let text: String
    
    var body: some View {
      Text(text)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(width: 65)
        .padding(.leading)
    }
    
    init(_ text: String) {
      self.text = text
    }
  }
  
  @Environment(\.modelContext) var modelContext
  
  let place: Place
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        Map(initialPosition: position(for: place), interactionModes: []) {
          Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
        }
        .frame(idealHeight: 225)
        
        VStack(alignment: .leading) {
          Text("Details")
            .font(.title3)
            .foregroundStyle(.secondary)
            .padding(.leading)
          
          Divider()
            .padding(.bottom, 4)
          VStack(alignment: .leading) {
            HStack(alignment: .center) {
              TextLabel("NAME:")
              TextField("Place Name", text: .constant(place.name))
                .textFieldStyle(.roundedBorder)
                .padding(.trailing)
            }
            .padding(.bottom, 4)
            HStack {
              TextLabel("NOTES:")
              TextField("Place Notes", text: .constant(place.notes))
                .textFieldStyle(.roundedBorder)
                .padding(.trailing)
            }
            .padding(.bottom, 4)
            HStack {
              TextLabel("ADDED:")
              DatePicker("Added Date", selection: .constant(place.addDate))
                .disabled(true)
                .labelsHidden()
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 4)
            HStack {
              TextLabel("EXPIRES:")
              DatePicker("Expiry Date", selection: .constant(place.expirationDate))
                .labelsHidden()
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 4)
          }
          
          Divider()
            .padding(.bottom, 4)
          
          Text("Images")
            .font(.title3)
            .foregroundStyle(.secondary)
            .padding(.leading)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              ForEach(place.imageNames, id: \.self) { imageName in
                Image(imageName)
                  .resizable()
                  .frame(width: 160, height: 160)
                  .clipShape(.rect(cornerRadius: 5))
              }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 4)
          }
          
          Divider()
            .padding(.bottom, 4)
          
          Text("Review")
            .font(.title3)
            .foregroundStyle(.secondary)
            .padding(.leading)
          
          TextField("Review", text: .constant(place.review), axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding([.leading, .trailing])
        }
      }
      .navigationTitle(place.name)
      .navigationBarTitleDisplayMode(.inline)
      .background(.thinMaterial)
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
