//
//  Privacy.swift
//
//
//  Created by Joshua Kraft on 9/14/24.
//

import Foundation
import Ignite

// swiftlint: disable line_length
struct Privacy: StaticPage {
  var title = "Privacy Statement"

  func body(context: PublishingContext) async -> [any BlockElement] {
    navigationBar()

    Text("Privacy Statement")
      .font(.title1)
      .horizontalAlignment(.center)

    Group {
      Text("DontGoThere is committed to ensuring your privacy. The app does not collect, share, or transmit any data from your use of the app.")
        .font(.lead)
        .horizontalAlignment(.center)

      Text("DontGoThere utilizes Location Services solely to display your current location on the PlaceMap, to allow you to add places at your current location, and to monitor changes in your location to help you avoid revisiting places where you’ve had previous undesirable experiences. The locations of these places are stored on your devices or in your iCloud account and are not collected.")

      Text("The app only stores the locations of the places you choose to add. While DontGoThere monitors your location in real time to provide its core functionality, this information is never collected, shared, or used beyond the purpose of alerting you to avoid specific places.")

      Text("DontGoThere allows you to attach photos to places you’ve added. If you grant camera access, the app will allow you to take photos and associate them with those places. DontGoThere only accesses the photos you explicitly select, and these photos are stored solely on your device or within your iCloud account, depending on your device settings. No photos are collected or shared by DontGoThere.")

      Text("DontGoThere will send you a maximum of one notification per place per day and will respect the limits you configure in the app settings regarding maximum notifications per place.")
    }
    .padding(.horizontal, 10)
  }
}
// swiftlint: enable line_length
