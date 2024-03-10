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
  
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
  let container: ModelContainer
  var archivalController: ArchivalController
  
  @StateObject var locationController = LocationController.shared
  @StateObject var appSettings = AppSettings.loadSettings()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appSettings)
        .environmentObject(locationController)
        .onAppear {
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
    } catch {
      fatalError("Could not create container: \(error.localizedDescription)")
    }
  }
}
