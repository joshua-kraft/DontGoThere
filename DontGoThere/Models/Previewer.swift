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
  var expiredPlace: Place
  
  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let settings = AppSettings.defaultSettings
    container = try ModelContainer(for: Place.self, configurations: config)
    place = Place(name: "Example Place Name", notes: "Headline of what was bad", review: "A little bit longer text so that we can see what wrapping looks like in the multi-line text field when writing a particularly long or multi-lined review.\n\nMaybe there are two paragraphs. Who knows what people could write when they're upset.", latitude: 30.5788, longitude: -97.8531, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(settings.autoExpiryInterval), imageData: [])
    expiredPlace = Place(name: "Archived Place Name", notes: "Headline of what was bad", review: "A little bit longer text so that we can see what wrapping looks like in the multi-line text field when writing a particularly long or multi-lined review.\n\nMaybe there are two paragraphs. Who knows what people could write when they're upset.", latitude: 30.5788, longitude: -97.8531, addDate: Date.now.addingTimeInterval(-30 * 86400), expirationDate: Date.now.addingTimeInterval(-1 * 86400), imageData: [], isExpired: true)
    container.mainContext.insert(place)
  }
}
