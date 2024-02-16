//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftUI

struct ContentView: View {
  
  @State private var listSearchText = ""
  
  var body: some View {
    TabView {
      PlacesListView()
        .searchable(text: $listSearchText)
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
    .modelContainer(Place.listPreview)
}
