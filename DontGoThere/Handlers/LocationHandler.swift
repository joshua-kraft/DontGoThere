//
//  LocationHandler.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/1/24.
//

import CoreLocation
import Foundation
import SwiftData
import SwiftUI

@MainActor class LocationHandler: NSObject, ObservableObject {

  static let shared = LocationHandler()

  private var manager: CLLocationManager
  private var background: CLBackgroundActivitySession?
  var monitor: CLMonitor?
  let monitorName = "DontGoThereCLMonitor"
  private var places = [Place]()

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
    self.manager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func startLocationUpdates() {
    Task {
      do {
        self.updatesStarted = true
        let updates = CLLocationUpdate.liveUpdates()

        for try await update in updates {
          if !self.updatesStarted { break }

          if let loc = update.location {
            self.lastLocation = loc
            self.isStationary = update.isStationary
          }
        }
      } catch {
        print("Could not start location updates")
      }
      return
    }
  }

  func updateMonitorConditions() async {
    monitor = await CLMonitor(monitorName)
    let activePlaceUUIDs = places.filter({ !$0.isArchived }).compactMap({ $0.id.uuidString })

    // Add conditions for all active places
    // Conditions get the same UUID as the place
    for place in places where !place.isArchived {
      await monitor!.add(place.region, identifier: place.id.uuidString, assuming: .unsatisfied)
      print("created condition for \(place.name)")
    }

    // Remove any conditions we may have that aren't in the active place list
    for uuid in await monitor!.identifiers where !activePlaceUUIDs.contains(uuid) {
        await monitor!.remove(uuid)
        print("removed condition for \(uuid)")
    }
  }

  func startMonitoringPlaceConditions() async {
    guard let monitor else { return }

    Task {
      for try await event in await monitor.events {
        switch event.state {
        case .satisfied:
          // 30.56037
          // -97.84581
          // move to and away from here to test
          print("satisfied an event")
        case .unsatisfied, .unknown, .unmonitored:
          // Don't need to do anything here
          break
        @unknown default:
          // Could be exercised on API updates
          break
        }
      }
    }
  }

  func addConditionToMonitor(condition: CLMonitor.CircularGeographicCondition, id: String) async {
    await monitor?.add(condition, identifier: id, assuming: .unsatisfied)
    print("created condition for \(id)")
  }

  func removeConditionFromMonitor(id: String) async {
    await monitor?.remove(id)
    print("removed condition for \(id)")
  }

  func stopLocationUpdates() {
    self.updatesStarted = false
    self.backgroundActivity = false
  }
}

extension Notification.Name {
  static let locationPermissionsDenied = Notification.Name("locationPermissionsDenied")
  static let locationPermissionsAuthorizedWhenInUse = Notification.Name("locationPermissionAuthorizedWhenInUse")
  static let locationPermissionsRestricted = Notification.Name("locationPermissionsRestricted")
}

// MARK: CLLocationManagerDelegate Conformance
extension LocationHandler: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {

    case .notDetermined:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      self.locationAuthorized = false
      self.manager.requestAlwaysAuthorization()

    case .restricted:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      self.locationAuthorized = false
      NotificationCenter.default.post(name: .locationPermissionsRestricted, object: nil)

    case .denied:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      self.backgroundActivity = false
      self.updatesStarted = false
      self.locationAuthorized = false
      self.stopLocationUpdates()
      NotificationCenter.default.post(name: .locationPermissionsDenied, object: nil)

    case .authorizedAlways, .authorizedWhenInUse:
      // This is what we want
      UserDefaults.standard.setValue(true, forKey: "locationAuthorized")
      self.locationAuthorized = true
      self.startLocationUpdates()
      Task {
        await self.updateMonitorConditions()
        await self.startMonitoringPlaceConditions()
      }
      // Start the background activity if we're allowed, otherwise display the alert that we're not
      manager.authorizationStatus == .authorizedAlways ?
      self.backgroundActivity = true :
      NotificationCenter.default.post(name: .locationPermissionsAuthorizedWhenInUse, object: nil)

    @unknown default:
      // Could be reached if Apple adds to CLAuthorizationStatus
      break
    }
  }
}

// MARK: - Fetching SwiftData objects
extension LocationHandler {
  func fetchData(modelContext: ModelContext) {
    do {
      let descriptor = FetchDescriptor<Place>()
      places = try modelContext.fetch(descriptor)
    } catch {
      print("Fetch failed: \(error.localizedDescription)")
    }
  }
}
