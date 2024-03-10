//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.openURL) var openURL

  @State private var showingLocationDeniedAlert = false
  @State private var showingLocationAllowedInUseOnlyAlert = false
  @State private var showingLocationRestrictedAlert = false
  @AppStorage("locationDeniedAlertCount") private var locationDeniedAlertCount = 0
  @AppStorage("locationAllowedOnlyInUseAlertCount") private var locationAllowedOnlyInUseAlertCount = 0
  @AppStorage("locationRestrictedAlertCount") private var locationRestrictedAlertCount = 0

  var body: some View {
    TabView {
      PlacesListView()
        .tabItem {
          Label("PlaceList", systemImage: "list.triangle")
        }

      PlacesMapView()
        .tabItem {
          Label("PlaceMap", systemImage: "map")
        }

      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.2")
        }
    }
    .onReceive(NotificationCenter.default.publisher(for: .locationPermissionsDenied)) { _ in
      if locationDeniedAlertCount == 0 {
        locationDeniedAlertCount += 1
        showingLocationDeniedAlert.toggle()
      }
    }
    .alert("Location Services Denied", isPresented: $showingLocationDeniedAlert) {
      Button("Settings") {
        openURL(URL(string: UIApplication.openSettingsURLString)!)
      }
      Button("Keep Denied", role: .cancel) { }
    } message: {
      Text("Denying location services will reduce the intended functionality of DontGoThere. ")
      + Text("DontGoThere wont be able to show or add places at your current location. ")
      + Text("Additionally, DontGoThere won't be able to send you notifications not to go to a place.")
    }
    .onReceive(NotificationCenter.default.publisher(for: .locationPermissionsAuthorizedWhenInUse)) { _ in
      if locationAllowedOnlyInUseAlertCount == 0 {
        locationAllowedOnlyInUseAlertCount += 1
        showingLocationAllowedInUseOnlyAlert.toggle()
      }
    }
    .alert("Location Only Authorized While In Use", isPresented: $showingLocationAllowedInUseOnlyAlert) {
      Button("Settings") {
        openURL(URL(string: UIApplication.openSettingsURLString)!)
      }
      Button("Keep Only In Use", role: .cancel) { }
    } message: {
      Text("This means that DontGoThere won't be able to notify you as you approach a place.")
    }
    .onReceive(NotificationCenter.default.publisher(for: .locationPermissionsRestricted)) { _ in
      if locationRestrictedAlertCount == 0 {
        locationRestrictedAlertCount += 1
        showingLocationRestrictedAlert.toggle()
      }
    }
    .alert("Location Services Restricted", isPresented: $showingLocationRestrictedAlert) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Your location services are restricted on this device, likely due to parental controls. ")
      + Text("Contact the manager of your device to enable location services for DontGoThere.")
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
