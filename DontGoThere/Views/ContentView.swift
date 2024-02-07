//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      TabView {
        ListView()
          .tabItem {
            Label("List", systemImage: "list.triangle")
          }
        
        MapView()
          .tabItem {
            Label("Map", systemImage: "map")
          }
      }
    }
}

#Preview {
    ContentView()
}
