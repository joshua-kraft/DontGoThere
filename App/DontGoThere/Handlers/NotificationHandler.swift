//
//  NotificationHandler.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import CoreLocation
import Foundation
import SwiftUI
import UserNotifications

class NotificationHandler: NSObject, ObservableObject {

  static let shared = NotificationHandler()

  let calendar = Calendar.autoupdatingCurrent

  func sendNotification(for place: Place, with event: CLMonitor.Event) {
    // Don't send notifications if the place was added today or if we already sent one today.

    guard !calendar.isDateInToday(place.addDate) else { return }

    guard !calendar.isDateInToday(place.lastNotificationDate) else { return }

    // If we got here, create a notification

    let unc = UNUserNotificationCenter.current()

    let addNotificationRequest = {
      let content = UNMutableNotificationContent()
      content.title = "Going to \(place.name)? DontGoThere!"
      content.subtitle = "You had a bad experience at \(place.name) on \(place.formattedAddDate)."
      content.sound = UNNotificationSound.default
      let userInfo: [String: String] = ["placeIdentifier": place.id.uuidString]
      content.userInfo = userInfo
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      unc.add(request)
    }

    unc.getNotificationSettings { notificationSettings in
      if notificationSettings.authorizationStatus == .authorized {
        place.lastNotificationDate = event.date
        place.notificationCount += 1
        addNotificationRequest()
      } else {
        // Not authorized to send a notification. Do nothing.
      }
    }
  }

  func requestNotificationPermissions() {
    let unc = UNUserNotificationCenter.current()

    unc.getNotificationSettings { notificationSettings in
      if notificationSettings.authorizationStatus == .notDetermined {
        unc.requestAuthorization(options: [.alert, .sound]) { success, error in
          if success {
          } else if let error {
            print(error.localizedDescription)
          }
        }
      }
    }
  }
}

extension Notification.Name {
  static let dontGoThereNotificationWasOpened = Notification.Name("dontGoThereNotificationWasOpened")
}

extension NotificationHandler: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    // Get the place ID from the original notification
    if let userInfo = response.notification.request.content.userInfo as? [String: String] {
      if let placeIdentifier = userInfo["placeIdentifier"] {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
          NotificationCenter.default.post(name: .dontGoThereNotificationWasOpened, object: placeIdentifier)
        default:
          // no actions besides the default one yet
          break
        }
      }
    }
  }
}
