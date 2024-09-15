//
//  File.swift
//  
//
//  Created by Joshua Kraft on 9/14/24.
//

import Foundation
import Ignite

struct Robots: RobotsConfiguration {
  var disallowRules: [DisallowRule]

  init() {
    disallowRules = [
      DisallowRule(robot: .chatGPT)
    ]
  }
}
