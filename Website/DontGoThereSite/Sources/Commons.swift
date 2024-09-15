//
//  Commons.swift
//
//
//  Created by Joshua Kraft on 9/14/24.
//

import Foundation
import Ignite

func navigationBar() -> NavigationBar {
  NavigationBar(logo: "DontGoThere") {
    Link("Privacy Statement", target: Privacy())
    Link("Support", target: Support())
  }
  .navigationBarStyle(.dark)
  .background(.royalBlue)
}
