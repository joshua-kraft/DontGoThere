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
  var archiveHandler: ArchiveHandler

  @StateObject var locationHandler = LocationHandler.shared
  @StateObject var appSettings = AppSettings.loadSettings()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appSettings)
        .environmentObject(locationHandler)
        .onAppear {
          archiveHandler.archiveExpiredPlaces()
          archiveHandler.deleteOldArchivedPlaces()
          try? locationHandler.fetchData()
        }
    }
    .modelContainer(container)
  }

  init() {
    do {
      container = try ModelContainer(for: Place.self)
      archiveHandler = ArchiveHandler(modelContext: container.mainContext, appSettings: AppSettings.loadSettings())
    } catch {
      fatalError("Could not create container: \(error.localizedDescription)")
    }
  }
}
