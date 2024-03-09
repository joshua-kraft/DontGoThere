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
  
  @EnvironmentObject var locationServicesController: LocationServicesController
  
  @State private var isShowingLocationServicesDeniedAlert = false
  @State private var isShowingLocationServicesAllowedInUseAlert = false
  @State private var isShowingLocationServicesRestrictedAlert = false
  
  @AppStorage("locationServicesDeniedAlertCount") private var locationServicesDeniedAlertCount = 0
  @AppStorage("locationServicesAllowedInUseOnlyAlertCount") private var locationServicesAllowedInUseOnlyAlertCount = 0
  @AppStorage("locationServicesRestrictedAlertCount") private var locationServicesRestrictedAlertCount = 0
  
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
      if locationServicesDeniedAlertCount == 0 {
        locationServicesDeniedAlertCount += 1
        isShowingLocationServicesDeniedAlert.toggle()
      }
    }
    .alert("Location Services Denied", isPresented: $isShowingLocationServicesDeniedAlert) {
      Button("Settings") {
        openURL(URL(string: UIApplication.openSettingsURLString)!)
      }
      Button("Keep Denied", role: .cancel) { }
    } message: {
      Text("Denying location services means that DontGoThere won't be able to add places at your current location, show your location to you on the PlaceMap, or notify you if you approach one of your places.")
    }
    .onReceive(NotificationCenter.default.publisher(for: .locationPermissionsAuthorizedWhenInUse)) { _ in
      if locationServicesAllowedInUseOnlyAlertCount == 0 {
        locationServicesAllowedInUseOnlyAlertCount += 1
        isShowingLocationServicesAllowedInUseAlert.toggle()
      }
    }
    .alert("Location Services Only Authorized While In Use", isPresented: $isShowingLocationServicesAllowedInUseAlert) {
      Button("Settings") {
        openURL(URL(string: UIApplication.openSettingsURLString)!)
      }
      Button("Keep Only In Use", role: .cancel) { }
    } message: {
      Text("Only allowing location services while in use means that DontGoThere won't be able to notify you as you approach a place.")
    }
    .onReceive(NotificationCenter.default.publisher(for: .locationPermissionsRestricted)) { _ in
      if locationServicesRestrictedAlertCount == 0 {
        locationServicesRestrictedAlertCount += 1
        isShowingLocationServicesRestrictedAlert.toggle()
      }
    }
    .alert("Location Services Restricted", isPresented: $isShowingLocationServicesRestrictedAlert) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Your location services are restricted on this device, likely due to parental controls. Contact the manager of your device to enable location services for DontGoThere.")
    }


  }
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return ContentView()
      .modelContainer(previewer.container)
      .environmentObject(LocationServicesController())
      .environmentObject(AppSettings.defaultSettings)
      
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
