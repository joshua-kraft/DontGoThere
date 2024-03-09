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
    
  }
  
  func deleteOldArchivedPlaces() {
    
  }
}
