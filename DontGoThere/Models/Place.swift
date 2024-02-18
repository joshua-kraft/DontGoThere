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
  var notes: String
  var review: String

  // location of a place
  var latitude: Double
  var longitude: Double
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  // TODO: add geofencing values
  
  var addDate: Date
  var expirationDate: Date
  var neverExpires: Bool
  
  var formattedAddDate: String {
    formattedDate(addDate)
  }
  
  var formattedExpirationDate: String {
    formattedDate(expirationDate)
  }
  
  @Attribute(.externalStorage) var imageData: [Data]?
  
  var isArchived: Bool
  
  init(name: String, notes: String, review: String, latitude: Double, longitude: Double, addDate: Date, expirationDate: Date, imageData: [Data]? = nil, isArchived: Bool = false, neverExpires: Bool = false) {
    self.name = name
    self.notes = notes
    self.review = review
    self.latitude = latitude
    self.longitude = longitude
    self.addDate = addDate
    self.expirationDate = expirationDate
    self.imageData = imageData
    self.isArchived = isArchived
    self.neverExpires = neverExpires
  }
  
  func formattedDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .short
    df.locale = .autoupdatingCurrent
    return df.string(from: date)
  }
}

