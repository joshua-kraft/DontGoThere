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

  private var manager: CLLocationManager?
  private var background: CLBackgroundActivitySession?
  var monitor: CLMonitor?
  let monitorName = "DontGoThereCLMonitor"
  private var places = [Place]()

  let notificationHandler = NotificationHandler.shared

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
    super.init()
  }

  func startup() {
    self.manager = CLLocationManager()
    self.manager?.delegate = self
    self.manager?.desiredAccuracy = kCLLocationAccuracyBest
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
            if #available(iOS 18.0, *) {
              self.isStationary = update.stationary
            } else {
              self.isStationary = update.isStationary
            }
          }
        }
      } catch {
        print(error.localizedDescription)
      }
      return
    }
  }

  func startMonitoring() async {
    await self.updateMonitorConditions()
    await self.startMonitoringPlaceConditions()
  }

  private func updateMonitorConditions() async {
    try? fetchPlaces()
    monitor = await CLMonitor(monitorName)
    let activePlaceUUIDs = places.filter({ !$0.isArchived }).compactMap({ $0.id.uuidString })

    // Add conditions for all active places
    // Conditions get the same UUID as the place
    for place in places where !place.isArchived {
      await monitor!.add(place.region, identifier: place.id.uuidString, assuming: .unsatisfied)
    }

    // Remove any conditions we may have that aren't in the active place list
    for uuid in await monitor!.identifiers where !activePlaceUUIDs.contains(uuid) {
      await monitor!.remove(uuid)
    }
  }

  private func startMonitoringPlaceConditions() async {
    guard let monitor else { return }

    Task {
      for try await event in await monitor.events {
        switch event.state {
        case .satisfied:
          try? self.fetchPlaces()
          if let place = places.filter({ $0.id.uuidString == event.identifier }).first {
            notificationHandler.sendNotification(for: place, with: event)
          }
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
    try? fetchPlaces()
    await monitor?.add(condition, identifier: id, assuming: .unsatisfied)
  }

  func removeConditionFromMonitor(id: String) async {
    try? fetchPlaces()
    await monitor?.remove(id)
  }

  func stopLocationUpdates() {
    self.updatesStarted = false
    self.backgroundActivity = false
  }
}

// MARK: CLLocationManagerDelegate Conformance
extension LocationHandler: @preconcurrency CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {

    case .notDetermined:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      self.locationAuthorized = false
      manager.requestWhenInUseAuthorization()

    case .restricted:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      self.locationAuthorized = false

    case .denied:
      UserDefaults.standard.setValue(false, forKey: "locationAuthorized")
      self.backgroundActivity = false
      self.updatesStarted = false
      self.locationAuthorized = false
      self.stopLocationUpdates()

    case .authorizedAlways, .authorizedWhenInUse:
      // This is what we want
      UserDefaults.standard.setValue(true, forKey: "locationAuthorized")
      self.locationAuthorized = true
      self.startLocationUpdates()
      Task {
        await self.updateMonitorConditions()
        await self.startMonitoringPlaceConditions()
      }
      // Start the background activity if we're allowed
      self.backgroundActivity = true

    @unknown default:
      // Could be reached if Apple adds to CLAuthorizationStatus
      break
    }
  }
}

// MARK: - Fetching SwiftData objects
extension LocationHandler {
  func fetchPlaces() throws {
    let container = try ModelContainer(for: Place.self)
    let context = container.mainContext

    do {
      let descriptor = FetchDescriptor<Place>()
      places = try context.fetch(descriptor)
    } catch {
      print(error.localizedDescription)
    }
  }
}
