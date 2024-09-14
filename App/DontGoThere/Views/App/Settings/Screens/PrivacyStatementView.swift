//
//  PrivacyStatementView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct PrivacyStatementView: View {

  @EnvironmentObject var appSettings: AppSettings

  var body: some View {
    ScrollView(.vertical) {
      VStack {
        Text(appSettings.privacyStatement!)
          .padding([.top, .leading, .trailing])
      }
      .navigationTitle("Privacy Statement")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  PrivacyStatementView()
    .environmentObject(AppSettings.defaultSettings)
}
