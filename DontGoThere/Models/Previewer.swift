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
    activePlace = Place(name: "Example Place Name",
                        review: "A little bit longer text so that we can see what wrapping looks like in"
                        + "the multi-line text field when writing a particularly long or multi-lined review.\n\n"
                        + "Maybe there are two paragraphs. Who knows what people could write when they're upset.",
                        latitude: 30.5532, longitude: -97.8422, radius: settings.regionRadius,
                        address: Address(streetNumber: "123",
                                         streetName: "Example Esp",
                                         city: "Example",
                                         state: "ZZ",
                                         zip: "12345"),
                        maxNotificationCount: settings.maxNotificationCount,
                        addDate: Date.now,
                        expirationDate: settings.getExpiryDate(from: Date.now),
                        imageData: []
    )
    archivedPlace = Place(name: "Archived Place Name",
                          review: "A little bit longer text so that we can see what wrapping looks like in"
                          + "the multi-line text field when writing a particularly long or multi-lined review.\n\n"
                          + "Maybe there are two paragraphs. Who knows what people could write when they're upset.",
                          latitude: 30.5788, longitude: -97.8531, radius: settings.regionRadius,
                          address: Address(streetNumber: "999",
                                           streetName: "Archived Ave",
                                           city: "Archives",
                                           state: "ZZ",
                                           zip: "12345"),
                          isArchived: true,
                          maxNotificationCount: settings.maxNotificationCount,
                          addDate: Date.now.addingTimeInterval(-30 * 86400),
                          expirationDate: Date.now.addingTimeInterval(-1 * 86400),
                          imageData: []
    )
    neverExpiresPlace = Place(name: "TraPac",
                              review: "A little bit longer text so that we can see what wrapping looks like in"
                              + "the multi-line text field when writing a particularly long or multi-lined review.\n\n"
                              + "Maybe there are two paragraphs. Who knows what people could write when they're upset.",
                              latitude: 30.392660, longitude: -97.850010, radius: settings.regionRadius,
                              address: Address(streetNumber: "6500",
                                               streetName: "River Place Blvd",
                                               city: "Austin",
                                               state: "TX",
                                               zip: "78730"),
                              shouldExpire: false,
                              maxNotificationCount: settings.maxNotificationCount,
                              addDate: Date.now, expirationDate: Date.distantFuture,
                              imageData: []
    )
    container.mainContext.insert(activePlace)
    container.mainContext.insert(archivedPlace)
    container.mainContext.insert(neverExpiresPlace)
  }
}
