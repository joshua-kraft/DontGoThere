//
//  Place.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import Foundation
import SwiftData

@Model
class Place {
  // details about a place
  let name: String
  let notes: String
  let review: String

  // location of a place
  let latitude: Double
  let longitude: Double
  // TODO: add geofencing values
  
  let addDate: Date
  let expirationDate: Date
  
  var formattedAddDate: String {
    formattedDate(addDate)
  }
  
  var formattedExpirationDate: String {
    formattedDate(expirationDate)
  }
  
  let imageNames: [String]
  
  init(name: String, notes: String, review: String, latitude: Double, longitude: Double, addDate: Date, expirationDate: Date, imageNames: [String]) {
    self.name = name
    self.notes = notes
    self.review = review
    self.latitude = latitude
    self.longitude = longitude
    self.addDate = addDate
    self.expirationDate = expirationDate
    self.imageNames = imageNames
  }
  
  func formattedDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .short
    df.locale = .autoupdatingCurrent
    return df.string(from: date)
  }
}

