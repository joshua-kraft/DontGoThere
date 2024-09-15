//
//  HeaderBar.swift
//
//
//  Created by Joshua Kraft on 9/15/24.
//

import Foundation
import Ignite

struct HeaderBar: Component {
  func body(context: PublishingContext) -> [any PageElement] {
    NavigationBar(logo: "DontGoThere") {
      Link("Privacy Statement", target: Privacy())
      Link("Support", target: Support())
    }
    .navigationBarStyle(.dark)
    .background(.royalBlue)
    .position(.fixedTop)
  }
}
