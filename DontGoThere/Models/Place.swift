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
  // details about a place
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
  
  // location of a place
  var latitude: Double
  var longitude: Double
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
  
  init(name: String, review: String, latitude: Double, longitude: Double, address: Address, addDate: Date, expirationDate: Date, shouldExpire: Bool = true, imageData: [Data]? = nil, isArchived: Bool = false) {
    self.name = name
    self.review = review
    self.latitude = latitude
    self.longitude = longitude
    self.address = address
    self.addDate = addDate
    self.expirationDate = expirationDate
    self.shouldExpire = shouldExpire
    self.imageData = imageData
    self.isArchived = isArchived
  }
  
  func formattedDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .short
    df.locale = .autoupdatingCurrent
    return df.string(from: date)
  }
}

