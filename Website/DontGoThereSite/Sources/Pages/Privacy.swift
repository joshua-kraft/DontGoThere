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

    Text("DontGoThere does not collect any data from your use of the app.")
      .font(.lead)
      .horizontalAlignment(.center)

    Text("DontGoThere uses Location Services to show you your location on the PlaceMap, add places at your current location, and watch for changes in your location in order to help you avoid the places you've been where you don't want to be again.")

    Text("DontGoThere only stores the locations of the places you've added. While changes in your location are available for DontGoThere to monitor for the aforementioned reasons, no location data other than the locations of the places you add is ever stored.")

    Text("DontGoThere allows you to attach photos to the places you add. If you grant permission to use the camera, DontGoThere will allow you to take photos as well. DontGoThere only receives access to the photos you specify. Photos are only ever stored on your devices / in your iCloud data with DontGoThere.")

    Text("DontGoThere will only send you one notification per place per day, and will only send as many notifications as you specify in the application settings. You can disable the limit, but DontGoThere will never notify you more than once per place per day.")
  }
}
// swiftlint: enable line_length
