//
//  Labels.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import SwiftUI

struct HeaderLabel: View {
  let text: String

  var body: some View {
    Text(text)
      .font(.title3)
      .foregroundStyle(.secondary)
  }

  init(_ text: String) {
    self.text = text
  }
}

struct DetailLabel: View {
  let text: String

  var body: some View {
    Text(text)
      .font(.subheadline)
      .foregroundStyle(.secondary)
  }

  init(_ text: String) {
    self.text = text
  }
}
