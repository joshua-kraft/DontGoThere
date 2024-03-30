//
//  AppDelegate.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    let locationHandler = LocationHandler.shared

    // restart if they were previously active
    if locationHandler.updatesStarted {
      locationHandler.startLocationUpdates()
    }

    // restart background activity after launch
    if locationHandler.backgroundActivity {
      locationHandler.backgroundActivity = true
    }

    return true
  }
}
