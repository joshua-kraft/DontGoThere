//
//  AppSettings.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/17/24.
//

import Foundation
import SwiftUI

enum TimeUnit: String, CaseIterable, Codable {
  case days = "Day(s)"
  case weeks = "Week(s)"
  case months = "Month(s)"
  case years = "Year(s)"
}

class AppSettings: ObservableObject, Codable {
  
  static let defaultSettings = AppSettings(neverExpire: false, autoExpiryValue: 1, autoExpiryUnit: .months, autoExpiryInterval: 30.0 * 86400, neverDelete: false, autoDeletionValue: 1, autoDeletionUnit: .months, autoDeletionInterval: 30.0 * 86400, noNotificationLimit: false, maxNotificationCount: 10)
  
  @Published var neverExpire: Bool
  @Published var autoExpiryValue: Int
  @Published var autoExpiryUnit: TimeUnit
  @Published var autoExpiryInterval: Double
  
  @Published var neverDelete: Bool
  @Published var autoDeletionValue: Int
  @Published var autoDeletionUnit: TimeUnit
  @Published var autoDeletionInterval: Double
  
  @Published var noNotificationLimit: Bool
  @Published var maxNotificationCount: Int
  
    
  init(neverExpire: Bool, autoExpiryValue: Int, autoExpiryUnit: TimeUnit, autoExpiryInterval: Double, neverDelete: Bool, autoDeletionValue: Int, autoDeletionUnit: TimeUnit, autoDeletionInterval: Double, noNotificationLimit: Bool, maxNotificationCount: Int) {
    self.neverExpire = neverExpire
    self.autoExpiryValue = autoExpiryValue
    self.autoExpiryUnit = autoExpiryUnit
    self.autoExpiryInterval = autoExpiryInterval
    self.neverDelete = neverDelete
    self.autoDeletionValue = autoDeletionValue
    self.autoDeletionUnit = autoDeletionUnit
    self.autoDeletionInterval = autoDeletionInterval
    self.noNotificationLimit = noNotificationLimit
    self.maxNotificationCount = maxNotificationCount
  }
  
  static func loadSettings() -> AppSettings {
    if let settingsData = UserDefaults.standard.data(forKey: "DontGoThereSettings") {
      if let decodedSettings = try? JSONDecoder().decode(AppSettings.self, from: settingsData) {
        return decodedSettings
      } else {
        print("Failed to decode data")
        return AppSettings.defaultSettings
      }
    } else {
      print("Could not load data from UserDefaults")
      return AppSettings.defaultSettings
    }
  }
  
  func saveSettings() {
    if let encodedData = try? JSONEncoder().encode(self) {
      UserDefaults.standard.setValue(encodedData, forKey: "DontGoThereSettings")
    }
  }
  
  // MARK: - Codable conformance
  
  enum CodingKeys: CodingKey {
    case neverExpire
    case autoExpiryValue
    case autoExpiryUnit
    case autoExpiryInterval
    case neverDelete
    case autoDeletionValue
    case autoDeletionUnit
    case autoDeletionInterval
    case noNotificationLimit
    case maxNotificationCount
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    neverExpire = try container.decode(Bool.self, forKey: .neverExpire)
    autoExpiryValue = try container.decode(Int.self, forKey: .autoExpiryValue)
    autoExpiryUnit = try container.decode(TimeUnit.self, forKey: .autoExpiryUnit)
    autoExpiryInterval = try container.decode(Double.self, forKey: .autoExpiryInterval)
    
    neverDelete = try container.decode(Bool.self, forKey: .neverDelete)
    autoDeletionValue = try container.decode(Int.self, forKey: .autoDeletionValue)
    autoDeletionUnit = try container.decode(TimeUnit.self, forKey: .autoDeletionUnit)
    autoDeletionInterval = try container.decode(Double.self, forKey: .autoDeletionInterval)
    
    noNotificationLimit = try container.decode(Bool.self, forKey: .noNotificationLimit)
    maxNotificationCount = try container.decode(Int.self, forKey: .maxNotificationCount)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(neverExpire, forKey: .neverExpire)
    try container.encode(autoExpiryValue, forKey: .autoExpiryValue)
    try container.encode(autoExpiryUnit, forKey: .autoExpiryUnit)
    try container.encode(autoExpiryInterval, forKey: .autoExpiryInterval)

    try container.encode(neverDelete, forKey: .neverDelete)
    try container.encode(autoDeletionValue, forKey: .autoDeletionValue)
    try container.encode(autoDeletionUnit, forKey: .autoDeletionUnit)
    try container.encode(autoDeletionInterval, forKey: .autoDeletionInterval)

    try container.encode(noNotificationLimit, forKey: .noNotificationLimit)
    try container.encode(maxNotificationCount, forKey: .maxNotificationCount)
  }

}
