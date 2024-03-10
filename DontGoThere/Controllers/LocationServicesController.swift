//
//  LocationServicesController.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/1/24.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI

extension Notification.Name {
  static let locationPermissionsDenied = Notification.Name("locationPermissionsDenied")
  static let locationPermissionsAuthorizedWhenInUse = Notification.Name("locationPermissionAuthorizedWhenInUse")
  static let locationPermissionsRestricted = Notification.Name("locationPermissionsRestricted")
}

class LocationServicesController: NSObject, CLLocationManagerDelegate, ObservableObject {
  
  var locationManager: CLLocationManager?
  let geocoder = CLGeocoder()

  let allowedLocationAuths: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
  var locationAuthorized: Bool {
    guard let locationManager else { return false }
    return allowedLocationAuths.contains(locationManager.authorizationStatus)
  }
  
  
  // MARK: - CLLocationManagerDelegate Conformance + Permissions
  func checkLocationAuth() {
    guard let locationManager = locationManager else {
      // Initialize the location manager if it didn't exist.
      // This will call the delegate method which will in turn call this method and pass through this guard statement.
      locationManager = CLLocationManager()
      locationManager!.desiredAccuracy = kCLLocationAccuracyBest
      locationManager!.distanceFilter = kCLDistanceFilterNone
      locationManager!.delegate = self
      return
    }
    
    // request location authorization or post a notification so the user can be prompted to fix it or at least be aware of the effects
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    case .restricted:
      NotificationCenter.default.post(name: .locationPermissionsRestricted, object: nil)
    case .denied:
      NotificationCenter.default.post(name: .locationPermissionsDenied, object: nil)
    case .authorizedAlways:
      // this is the status we want - we don't need to do anything else
      break
    case .authorizedWhenInUse:
      NotificationCenter.default.post(name: .locationPermissionsAuthorizedWhenInUse, object: nil)
    case .authorized:
      // this is a deprecated status replaced by authorizedAlways
      break
    @unknown default:
      // Could be reached if Apple adds values to CLAuthorizationStatus
      break
    }
    
  }
    
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuth()
  }
  
}

// MARK: - Geocoding
extension LocationServicesController {
  
  func getNameForCurrentLocation() -> String {
    if let name = MKMapItem.forCurrentLocation().name {
      if name.contains("Unknown") {
        return ""
      } else {
        return name
      }
    } else {
      return ""
    }
  }
  
  // Geocoding
    
  func getAddressFromCoordinate(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (MKPlacemark) -> ()) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
      if error != nil {
        print("error in geocoding")
        return
      }
      
      if let placemarks, let placemark = placemarks.first {
        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        print("error finding placemark")
        return
      }
      
    }
  }
  
  func getCoordinateFromAddress(address: String, completionHandler: @escaping (MKPlacemark) -> ()) {
    geocoder.geocodeAddressString(address) { placemarks, error in
      if error != nil {
        print("error in geocoding")
        return
      }
      
      if let placemarks, let placemark = placemarks.first {
        completionHandler(MKPlacemark(placemark: placemark))
      } else {
        print("error finding plcemark")
        return
      }
    }
  }
}

// MARK: - Regions
extension LocationServicesController {
  
}
