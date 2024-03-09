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

  @StateObject var appSettings = AppSettings.loadSettings()
  @StateObject var locationServicesController = LocationServicesController()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appSettings)
        .environmentObject(locationServicesController)
      
    }
    .modelContainer(container)
  }
  
  init() {
    do {
      container = try ModelContainer(for: Place.self)
      archivalController = ArchivalController(modelContext: container.mainContext)
    } catch {
      fatalError("Could not create container: \(error.localizedDescription)")
    }
  }
}
