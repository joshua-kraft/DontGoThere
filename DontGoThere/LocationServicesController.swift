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
  
  func checkIfLocationServicesEnabled() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager!.desiredAccuracy = kCLLocationAccuracyBest
      locationManager!.delegate = self
    } else {
      // Figure out how to show an alert that Location Services are disabled
    }
  }
  
  func checkLocationAuth() {
    guard let locationManager = locationManager else { return }
    
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
