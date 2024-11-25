//
//  SettingsHandler.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/17/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import Foundation
import SwiftUI

enum TimeUnit: String, CaseIterable, Codable {
  case days = "Day(s)"
  case weeks = "Week(s)"
  case months = "Month(s)"
  case years = "Year(s)"
}

class SettingsHandler: ObservableObject, Codable {

  static let shared = SettingsHandler()

  static let defaults = SettingsHandler(neverExpire: false,
                                           autoExpiryValue: 3,
                                           autoExpiryUnit: .months,
                                           neverDelete: false,
                                           autoDeletionValue: 1,
                                           autoDeletionUnit: .months,
                                           regionRadius: 30,
                                           noNotificationLimit: false,
                                           maxNotificationCount: 10)

  static let privacyURL: URL = .init(string: "https://www.dontgothere.app/privacy/")!
  static let supportURL: URL = .init(string: "https://www.dontgothere.app/support/")!

  let calendar = Calendar.autoupdatingCurrent

  @Published var neverExpire: Bool { didSet { saveSettings() } }
  @Published var autoExpiryValue: Int { didSet { saveSettings() } }
  @Published var autoExpiryUnit: TimeUnit { didSet { saveSettings() } }

  @Published var neverDelete: Bool { didSet { saveSettings() } }
  @Published var autoDeletionValue: Int { didSet { saveSettings() } }
  @Published var autoDeletionUnit: TimeUnit { didSet { saveSettings() } }

  @Published var regionRadius: Double { didSet { saveSettings() } }

  @Published var noNotificationLimit: Bool { didSet { saveSettings() } }
  @Published var maxNotificationCount: Int { didSet { saveSettings() } }

  init(neverExpire: Bool,
       autoExpiryValue: Int,
       autoExpiryUnit: TimeUnit,
       neverDelete: Bool,
       autoDeletionValue: Int,
       autoDeletionUnit: TimeUnit,
       regionRadius: Double,
       noNotificationLimit: Bool,
       maxNotificationCount: Int) {
    self.neverExpire = neverExpire
    self.autoExpiryValue = autoExpiryValue
    self.autoExpiryUnit = autoExpiryUnit
    self.neverDelete = neverDelete
    self.autoDeletionValue = autoDeletionValue
    self.autoDeletionUnit = autoDeletionUnit
    self.regionRadius = regionRadius
    self.noNotificationLimit = noNotificationLimit
    self.maxNotificationCount = maxNotificationCount
  }

  init() {
    if let settings = SettingsHandler.loadSettings() {
      self.neverExpire = settings.neverExpire
      self.autoExpiryValue = settings.autoExpiryValue
      self.autoExpiryUnit = settings.autoExpiryUnit
      self.neverDelete = settings.neverDelete
      self.autoDeletionValue = settings.autoDeletionValue
      self.autoDeletionUnit = settings.autoDeletionUnit
      self.regionRadius = settings.regionRadius
      self.noNotificationLimit = settings.noNotificationLimit
      self.maxNotificationCount = settings.maxNotificationCount
    } else {
      self.neverExpire = SettingsHandler.defaults.neverExpire
      self.autoExpiryValue = SettingsHandler.defaults.autoExpiryValue
      self.autoExpiryUnit = SettingsHandler.defaults.autoExpiryUnit
      self.neverDelete = SettingsHandler.defaults.neverDelete
      self.autoDeletionValue = SettingsHandler.defaults.autoDeletionValue
      self.autoDeletionUnit = SettingsHandler.defaults.autoDeletionUnit
      self.regionRadius = SettingsHandler.defaults.regionRadius
      self.noNotificationLimit = SettingsHandler.defaults.noNotificationLimit
      self.maxNotificationCount = SettingsHandler.defaults.maxNotificationCount
    }

    saveSettings()
  }

  static func loadSettings() -> SettingsHandler? {
    if let settingsData = UserDefaults.standard.data(forKey: "DontGoThereSettings") {
      if let decodedSettings = try? JSONDecoder().decode(SettingsHandler.self, from: settingsData) {
        return decodedSettings
      } else {
        return nil
      }
    } else {
      return nil
    }
  }

  func saveSettings() {
    if let encodedData = try? JSONEncoder().encode(self) {
      UserDefaults.standard.setValue(encodedData, forKey: "DontGoThereSettings")
    }
  }

  func getExpiryDate(from addDate: Date) -> Date {
    switch autoExpiryUnit {
    case .days:
      calendar.date(byAdding: .day, value: autoExpiryValue, to: addDate) ?? addDate
    case .weeks:
      calendar.date(byAdding: .weekOfYear, value: autoExpiryValue, to: addDate) ?? addDate
    case .months:
      calendar.date(byAdding: .month, value: autoExpiryValue, to: addDate) ?? addDate
    case .years:
      calendar.date(byAdding: .year, value: autoExpiryValue, to: addDate) ?? addDate
    }
  }

  func getDeletionDate(from expiryDate: Date) -> Date {
    switch autoDeletionUnit {
    case .days:
      calendar.date(byAdding: .day, value: autoDeletionValue, to: expiryDate) ?? expiryDate
    case .weeks:
      calendar.date(byAdding: .weekOfYear, value: autoDeletionValue, to: expiryDate) ?? expiryDate
    case .months:
      calendar.date(byAdding: .month, value: autoDeletionValue, to: expiryDate) ?? expiryDate
    case .years:
      calendar.date(byAdding: .year, value: autoExpiryValue, to: expiryDate) ?? expiryDate
    }
  }

  // MARK: - Codable conformance

  enum CodingKeys: CodingKey {
    case neverExpire
    case autoExpiryValue
    case autoExpiryUnit
    case neverDelete
    case autoDeletionValue
    case autoDeletionUnit
    case regionRadius
    case noNotificationLimit
    case maxNotificationCount
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    neverExpire = try container.decode(Bool.self, forKey: .neverExpire)
    autoExpiryValue = try container.decode(Int.self, forKey: .autoExpiryValue)
    autoExpiryUnit = try container.decode(TimeUnit.self, forKey: .autoExpiryUnit)

    neverDelete = try container.decode(Bool.self, forKey: .neverDelete)
    autoDeletionValue = try container.decode(Int.self, forKey: .autoDeletionValue)
    autoDeletionUnit = try container.decode(TimeUnit.self, forKey: .autoDeletionUnit)

    regionRadius = try container.decode(Double.self, forKey: .regionRadius)

    noNotificationLimit = try container.decode(Bool.self, forKey: .noNotificationLimit)
    maxNotificationCount = try container.decode(Int.self, forKey: .maxNotificationCount)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(neverExpire, forKey: .neverExpire)
    try container.encode(autoExpiryValue, forKey: .autoExpiryValue)
    try container.encode(autoExpiryUnit, forKey: .autoExpiryUnit)

    try container.encode(neverDelete, forKey: .neverDelete)
    try container.encode(autoDeletionValue, forKey: .autoDeletionValue)
    try container.encode(autoDeletionUnit, forKey: .autoDeletionUnit)

    try container.encode(regionRadius, forKey: .regionRadius)

    try container.encode(noNotificationLimit, forKey: .noNotificationLimit)
    try container.encode(maxNotificationCount, forKey: .maxNotificationCount)
  }
}
