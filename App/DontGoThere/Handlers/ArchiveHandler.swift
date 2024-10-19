//
//  ArchiveHandler.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import Foundation
import SwiftData

@Observable @MainActor
class ArchiveHandler: ObservableObject {
  var modelContext: ModelContext
  var settingsHandler: SettingsHandler
  var places = [Place]()

  init(modelContext: ModelContext, settingsHandler: SettingsHandler) {
    self.modelContext = modelContext
    self.settingsHandler = settingsHandler
    fetchData()
  }

  func fetchData() {
    do {
      let descriptor = FetchDescriptor<Place>()
      places = try modelContext.fetch(descriptor)
    } catch {
      print(error.localizedDescription)
    }
  }

  func archiveExpiredPlaces() {
    if settingsHandler.neverExpire { return }
    let activePlaces = places.filter({ !$0.isArchived })
    for place in activePlaces {
      if place.expirationDate < Date.now
          || (!settingsHandler.noNotificationLimit && place.notificationCount > settingsHandler.maxNotificationCount) {
        place.isArchived = true
      }
    }
  }

  func deleteOldArchivedPlaces() {
    if settingsHandler.neverDelete { return }
    let archivedPlaces = places.filter({ $0.isArchived })
    for place in archivedPlaces where settingsHandler.getDeletionDate(from: place.expirationDate) < Date.now {
      modelContext.delete(place)
    }
  }
}
