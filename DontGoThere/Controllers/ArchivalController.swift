//
//  ArchivalController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import Foundation
import SwiftData

@Observable
class ArchivalController: ObservableObject {
  
  var modelContext: ModelContext
  var appSettings: AppSettings
  var places = [Place]()
  
  init(modelContext: ModelContext, appSettings: AppSettings) {
    self.modelContext = modelContext
    self.appSettings = appSettings
    fetchData()
  }
  
  func fetchData() {
    do {
      let descriptor = FetchDescriptor<Place>()
      places = try modelContext.fetch(descriptor)
    } catch {
      print("Fetch failed: \(error.localizedDescription)")
    }
  }
  
  func archiveExpiredPlaces() {
    let activePlaces = places.filter({ !$0.isArchived })
    for place in activePlaces {
      if place.expirationDate < Date.now {
        place.isArchived = true
      }
    }
  }
  
  func deleteOldArchivedPlaces() {
    let archivedPlaces = places.filter({ $0.isArchived })
    for place in archivedPlaces {
      if appSettings.getDeletionDate(from: place.expirationDate) < Date.now {
        modelContext.delete(place)
      }
    }
  }
}
