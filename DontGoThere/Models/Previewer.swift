//
//  Previewer.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/16/24.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
  let container: ModelContainer
  let place: Place
  
  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    container = try ModelContainer(for: Place.self, configurations: config)
    place = Place(name: "Example Place Name", notes: "Headline of what was bad", review: "A little bit longer text so that we can see what wrapping looks like in the multi-line text field", latitude: 30.5788, longitude: -97.8531, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(365 * 86400), imageData: [])
    container.mainContext.insert(place)
  }
}
