//
//  SettingsHeaderView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct SettingsHeaderView: View {

  let headerTitle: String
  let headerNote: String

  init(headerTitle: String, headerNote: String) {
    self.headerTitle = headerTitle
    self.headerNote = headerNote
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(headerTitle)
        .padding(.bottom, 2)
      Text(headerNote)
        .textCase(.none)
        .font(.footnote)
        .padding(.leading, 6)
    }
  }
}

#Preview {
    SettingsHeaderView(headerTitle: "Header Title", headerNote: "Header Note")
}
