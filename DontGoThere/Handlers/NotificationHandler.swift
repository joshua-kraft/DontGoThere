//
//  NotificationHandler.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/9/24.
//

import CoreLocation
import Foundation
import SwiftUI

class NotificationHandler: ObservableObject {

  static let shared = NotificationHandler()

  let calendar = Calendar.autoupdatingCurrent

  func sendNotification(for place: Place, with event: CLMonitor.Event) {
    guard !calendar.isDateInToday(place.addDate) else {
      print("Not sending a notification because place was added today")
      return
    }

    guard !calendar.isDateInToday(place.lastNotificationDate) else {
      print("Not sending a notification because place has had a notification sent today")
      return
    }

    // If we got here, schedule an immediate notification.
    print("theoretically sent a notification")

    // Then set the last notification date.
    place.lastNotificationDate = event.date
    print("notification date set to \(event.date)")

    print("ending notification function")
  }

}
