//
//  Place.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import CoreLocation
import Foundation
import SwiftData

@Model
class Place: Identifiable {
  let id = UUID()
  var name: String
  var review: String

  var displayNotes: String {
    if review.count < 25 {
      return review
    } else {
      let endIndex = review.index(review.startIndex, offsetBy: 25)
      let range: Range<String.Index> = review.startIndex..<endIndex
      return String(review[range]).trimmingCharacters(in: .whitespacesAndNewlines) + "..."
    }
  }

  var latitude: Double
  var longitude: Double
  var radius: Double

  var coordinate: CLLocationCoordinate2D {
    .init(latitude: latitude, longitude: longitude)
  }

  var region: CLMonitor.CircularGeographicCondition {
    .init(center: coordinate, radius: radius)
  }

  var address: Address

  var shouldExpire: Bool
  var isArchived: Bool
  
  var notificationCount = 0
  var maxNotificationCount: Int

  var addDate: Date
  var expirationDate: Date

  var formattedAddDate: String {
    formattedDate(addDate)
  }

  var formattedExpirationDate: String {
    shouldExpire ? formattedDate(expirationDate) : "Never"
  }

  @Attribute(.externalStorage) var imageData: [Data]?

  init(name: String, 
       review: String,
       latitude: Double,
       longitude: Double,
       radius: Double,
       address: Address,
       shouldExpire: Bool = true,
       isArchived: Bool = false,
       notificationCount: Int = 0,
       maxNotificationCount: Int,
       addDate: Date,
       expirationDate: Date,
       imageData: [Data]? = nil) {
    self.name = name
    self.review = review
    self.latitude = latitude
    self.longitude = longitude
    self.radius = radius
    self.address = address
    self.shouldExpire = shouldExpire
    self.isArchived = isArchived
    self.notificationCount = notificationCount
    self.maxNotificationCount = maxNotificationCount
    self.addDate = addDate
    self.expirationDate = expirationDate
    self.imageData = imageData
  }

  func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.locale = .autoupdatingCurrent
    return formatter.string(from: date)
  }
}
