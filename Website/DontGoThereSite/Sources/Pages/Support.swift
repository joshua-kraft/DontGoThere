//
//  File.swift
//  
//
//  Created by Joshua Kraft on 9/14/24.
//

import Foundation
import Ignite

// swiftlint: disable line_length
struct Support: StaticPage {
  var title = "Support"

  func body(context: PublishingContext) async -> [any BlockElement] {
    navigationBar()

    Text("Support")
      .font(.title1)
      .horizontalAlignment(.center)

    Text("We're sorry to hear you're having problems with DontGoThere.")
      .font(.lead)
      .horizontalAlignment(.center)

    Text("Please submit a review on the App Store if you have a suggestion or complaint.")

    Text {
      "If you have a reproducible bug or crash, please email the details and steps to reproduce by emailing us at support@dontgothere.app or "

      Link("clicking here.", target: "mailto:support@dontgothere.app")
    }

    Text("Thank you for downloading and using DontGoThere.")

  }
}
// swiftlint: enable line_length
