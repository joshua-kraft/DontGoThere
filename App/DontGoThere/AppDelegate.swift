//
//  AppDelegate.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    let locationHandler = LocationHandler.shared
    let notificationHandler = NotificationHandler.shared

    // restart if they were previously active
    if locationHandler.updatesStarted {
      locationHandler.startLocationUpdates()
    }

    // restart background activity after launch
    if locationHandler.backgroundActivity {
      locationHandler.backgroundActivity = true
    }

    UNUserNotificationCenter.current().delegate = notificationHandler

    return true
  }
}
