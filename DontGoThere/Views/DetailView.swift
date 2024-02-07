//
//  DetailView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct DetailView: View {
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  
  let place: Place

  var body: some View {
    Text("DetailView for \(place.name)")
  }
}

#Preview {
  do {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Place.self, configurations: config)
    let examplePlace = Place(name: "Example Place Name", notes: "Example Notes Text", review: "Example Review Text", latitude: 30.55, longitude: -97.84, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(7 * 86400), imageNames: ["example1a", "example1b", "example1c"])
    
    return DetailView(place: examplePlace)
      .modelContainer(container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
