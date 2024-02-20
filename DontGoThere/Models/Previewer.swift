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
  let activePlace: Place
  let archivedPlace: Place
  let neverExpiresPlace: Place
  
  init() throws {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let settings = AppSettings.defaultSettings
    container = try ModelContainer(for: Place.self, configurations: config)
    activePlace = Place(name: "Example Place Name", review: "A little bit longer text so that we can see what wrapping looks like in the multi-line text field when writing a particularly long or multi-lined review.\n\nMaybe there are two paragraphs. Who knows what people could write when they're upset.", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: settings.getExpiryDate(from: Date.now), imageData: [])
    archivedPlace = Place(name: "Archived Place Name", review: "A little bit longer text so that we can see what wrapping looks like in the multi-line text field when writing a particularly long or multi-lined review.\n\nMaybe there are two paragraphs. Who knows what people could write when they're upset.", latitude: 30.5788, longitude: -97.8531, addDate: Date.now.addingTimeInterval(-30 * 86400), expirationDate: Date.now.addingTimeInterval(-1 * 86400), imageData: [], isArchived: true)
    neverExpiresPlace = Place(name: "Forever Place Name", review: "A little bit longer text so that we can see what wrapping looks like in the multi-line text field when writing a particularly long or multi-lined review.\n\nMaybe there are two paragraphs. Who knows what people could write when they're upset.", latitude: 30.5052, longitude: -97.8203, addDate: Date.now, expirationDate: Date.distantFuture, shouldExpire: false, imageData: [])
    container.mainContext.insert(activePlace)
    container.mainContext.insert(archivedPlace)
    container.mainContext.insert(neverExpiresPlace)
  }
}
