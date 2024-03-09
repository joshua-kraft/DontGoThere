//
//  DontGoThereApp.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

@main
struct DontGoThereApp: App {
  
  let container: ModelContainer
  var archivalController: ArchivalController
  var locationServicesController: LocationServicesController
  
  @StateObject var appSettings = AppSettings.loadSettings()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appSettings)
        .environmentObject(locationServicesController)
        .onAppear {
          locationServicesController.checkLocationAuth()
          archivalController.archiveExpiredPlaces()
          archivalController.deleteOldArchivedPlaces()
        }
      
    }
    .modelContainer(container)
  }
  
  init() {
    do {
      container = try ModelContainer(for: Place.self)
      archivalController = ArchivalController(modelContext: container.mainContext, appSettings: AppSettings.loadSettings())
      locationServicesController = LocationServicesController()
    } catch {
      fatalError("Could not create container: \(error.localizedDescription)")
    }
  }
}
