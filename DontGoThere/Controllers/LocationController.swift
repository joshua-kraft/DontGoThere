//
//  LocationController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/1/24.
//

import CoreLocation
import Foundation
import SwiftUI

@MainActor class LocationController: NSObject, ObservableObject {
  
  static let shared = LocationController()
  
  private var manager: CLLocationManager
  private var background: CLBackgroundActivitySession?
  
  @Published var lastLocation = CLLocation()
  @Published var isStationary = false
  @Published var count = 0
  
  @Published var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveUpdatesStarted") {
    didSet { UserDefaults.standard.set(updatesStarted, forKey: "liveUpdatesStarted") }
  }
  
  @Published var backgroundActivity: Bool = UserDefaults.standard.bool(forKey: "backgroundActivitySessionStarted") {
    didSet {
      backgroundActivity ? self.background = CLBackgroundActivitySession() : self.background?.invalidate()
      UserDefaults.standard.set(backgroundActivity, forKey: "backgroundActivitySessionStarted")
    }
  }
  
  @Published var locationAuthorized: Bool = UserDefaults.standard.bool(forKey: "locationAuthorized") {
    didSet { UserDefaults.standard.set(locationAuthorized, forKey: "locationAuthorized") }
  }
  
  override private init() {
    self.manager = CLLocationManager()
    super.init()
    
    self.manager.delegate = self
  }
  
  func startLocationUpdates() {
    if self.manager.authorizationStatus == .notDetermined {
      manager.requestAlwaysAuthorization()
    }
    print("starting location updates")
    Task {
      do {
        self.updatesStarted = true
        let updates = CLLocationUpdate.liveUpdates()
        
        for try await update in updates {
          if !self.updatesStarted { break }
          
          if let loc = update.location {
            self.lastLocation = loc
            self.isStationary = update.isStationary
            self.count += 1
            print("Location: \(self.count): \(self.lastLocation)")
          }
        }
      } catch {
        print("Could not start location updates")
      }
      return
    }
  }
  
  func stopLocationUpdates() {
    print("Stopping location updates")
    self.updatesStarted = false
  }
  
}

extension Notification.Name {
  static let locationPermissionsDenied = Notification.Name("locationPermissionsDenied")
  static let locationPermissionsAuthorizedWhenInUse = Notification.Name("locationPermissionAuthorizedWhenInUse")
  static let locationPermissionsRestricted = Notification.Name("locationPermissionsRestricted")
}

extension LocationController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .notDetermined:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      locationAuthorized = false
    case .restricted:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      locationAuthorized = false
      NotificationCenter.default.post(name: .locationPermissionsRestricted, object: nil)
    case .denied:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      locationAuthorized = false
      NotificationCenter.default.post(name: .locationPermissionsDenied, object: nil)
    case .authorizedAlways:
      // This is what we want
      UserDefaults.standard.setValue(true, forKey: "locationAuthorized")
      locationAuthorized = true
    case .authorizedWhenInUse:
      // Not optimal, but ok
      UserDefaults.standard.setValue(true, forKey: "locationAuthorized")
      locationAuthorized = true
      NotificationCenter.default.post(name: .locationPermissionsAuthorizedWhenInUse, object: nil)
    @unknown default:
      // Could be reached if Apple adds to CLAuthorizationStatus
      break
    }
  }
}
