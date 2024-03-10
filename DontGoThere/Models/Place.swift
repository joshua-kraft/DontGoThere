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

  var addDate: Date
  var expirationDate: Date
  var shouldExpire: Bool

  var formattedAddDate: String {
    formattedDate(addDate)
  }

  var formattedExpirationDate: String {
    shouldExpire ? formattedDate(expirationDate) : "Never"
  }

  @Attribute(.externalStorage) var imageData: [Data]?

  var isArchived: Bool

  var notificationCount = 0

  init(name: String,
       review: String,
       latitude: Double,
       longitude: Double,
       radius: Double,
       address: Address,
       addDate: Date,
       expirationDate: Date,
       shouldExpire: Bool = true,
       imageData: [Data]? = nil,
       isArchived: Bool = false) {
    self.name = name
    self.review = review
    self.latitude = latitude
    self.longitude = longitude
    self.radius = radius
    self.address = address
    self.addDate = addDate
    self.expirationDate = expirationDate
    self.shouldExpire = shouldExpire
    self.imageData = imageData
    self.isArchived = isArchived
  }

  func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.locale = .autoupdatingCurrent
    return formatter.string(from: date)
  }
}
