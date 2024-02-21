//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  
  @StateObject var appSettings = AppSettings.loadSettings()
  
  var body: some View {
    TabView {
      PlacesListView()
        .tabItem {
          Label("List", systemImage: "list.triangle")
        }
      
      PlacesMapView()
        .tabItem {
          Label("Map", systemImage: "map")
        }
      
      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.2")
        }
    }
    .environmentObject(appSettings)
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return ContentView()
      .modelContainer(previewer.container)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
