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

class LocationServicesController: NSObject, CLLocationManagerDelegate, ObservableObject {
  
  var locationManager: CLLocationManager?
  
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
    
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
    case .restricted:
      print("Location Services are restricted.")
    case .denied:
      print("Location Services are denied.")
    case .authorizedAlways: 
      print("Location Services are always authorized.")
    case .authorizedWhenInUse:
      print("Location Services authorized when in use.")
    case .authorized:
      print("Location Services authorized for single use.")
    @unknown default:
      // Could be reached if Apple adds values to CLAuthorizationStatus
      break
    }
    
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuth()
  }
  
}
