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
  
  var formattedAddDate: String {
    formattedDate(addDate)
  }
  
  var formattedExpirationDate: String {
    formattedDate(expirationDate)
  }
  
  var imageData = [Data]()
  
  init(name: String, notes: String, review: String, latitude: Double, longitude: Double, addDate: Date, expirationDate: Date) {
    self.name = name
    self.notes = notes
    self.review = review
    self.latitude = latitude
    self.longitude = longitude
    self.addDate = addDate
    self.expirationDate = expirationDate
  }
  
  func formattedDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.timeStyle = .none
    df.dateStyle = .short
    df.locale = .autoupdatingCurrent
    return df.string(from: date)
  }
}

extension Place {
  @MainActor
  static var listPreview: ModelContainer {
    let container = try! ModelContainer(for: Place.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let example1 = Place(name: "Bella Sera of Leander", notes: "Not good italian food", review: "", latitude: 30.5532, longitude: -97.8422, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(7 * 86400))
    let example2 = Place(name: "Phonatic Cedar Park", notes: "Not good thai food", review: "", latitude: 30.5266, longitude: -97.8089, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(7 * 86400))
    let example3 = Place(name: "First Watch Cedar Park", notes: "Eggs boiled-ict", review: "", latitude: 30.52525, longitude: -97.813760, addDate: Date.now, expirationDate: Date.now.addingTimeInterval(7 * 86400))
    container.mainContext.insert(example1)
    container.mainContext.insert(example2)
    container.mainContext.insert(example3)
    
    return container
  }
}

