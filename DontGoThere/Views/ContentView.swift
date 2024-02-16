//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  
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
  }
}

#Preview {
  ContentView()
    .modelContainer(Place.previewPlaces)
}
