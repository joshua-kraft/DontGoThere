//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {

  enum DontGoThereTabs: String {
    case list = "PlacesList"
    case map = "PlacesMap"
    case settings = "AppSettings"
  }

  @Environment(\.openURL) var openURL

  @State private var selectedTab: DontGoThereTabs = .list

  var body: some View {
    TabView(selection: $selectedTab) {
      PlacesListView()
        .tabItem {
          Label("PlaceList", systemImage: "list.triangle")
        }
        .tag(DontGoThereTabs.list)

      PlacesMapView()
        .tabItem {
          Label("PlaceMap", systemImage: "map")
        }
        .tag(DontGoThereTabs.map)

      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.2")
        }
        .tag(DontGoThereTabs.settings)
    }
    .onReceive(NotificationCenter.default.publisher(for: .dontGoThereNotificationWasOpened)) { _ in

      selectedTab = .list
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return ContentView()
      .modelContainer(previewer.container)
      .environmentObject(LocationHandler.shared)
      .environmentObject(AppSettings.defaultSettings)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
