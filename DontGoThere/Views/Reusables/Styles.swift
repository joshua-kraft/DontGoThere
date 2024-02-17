//
//  Styles.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/17/24.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      withAnimation {
        configuration.isOn.toggle()
      }
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        configuration.label
      }
    })
    .buttonStyle(.plain)
  }
}
