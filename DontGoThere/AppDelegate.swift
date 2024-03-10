//
//  AppDelegate.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    let locationsController = LocationController.shared
    
    // restart if they were previously active
    if locationsController.updatesStarted {
      locationsController.startLocationUpdates()
    }
    
    // restart background activity after launch
    if locationsController.backgroundActivity {
      locationsController.backgroundActivity = true
    }
    
    return true
  }
  
}
