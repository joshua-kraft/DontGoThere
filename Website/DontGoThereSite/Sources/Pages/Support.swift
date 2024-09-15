//
//  Support.swift
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
    Text("Support")
      .font(.title1)
      .horizontalAlignment(.center)

    Text("Sorry to hear you're having problems with DontGoThere.")
      .font(.lead)
      .horizontalAlignment(.center)

    Group {
      Text("Please submit a review on the App Store if you have a suggestion or complaint.")

      Text {
        "If you have a reproducible bug or crash, please email the details and steps to reproduce by emailing support@dontgothere.app or "

        Link("clicking here.", target: "mailto:support@dontgothere.app")
      }

      Text("Thank you for using DontGoThere.")
    }
    .padding(.horizontal, 10)

  }
}
// swiftlint: enable line_length
