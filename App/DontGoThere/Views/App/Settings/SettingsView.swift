//
//  SettingsView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/14/24.
//

import SwiftUI

struct SettingsView: View {

  @EnvironmentObject var settingsHandler: SettingsHandler

  var body: some View {
    NavigationStack {
      Form {

        Link("Privacy Statement", destination: SettingsHandler.privacyURL)

        Link("Support", destination: SettingsHandler.supportURL)

        SettingsExpirationSectionView()

        SettingsDeletionSectionView()

        SettingsNotificationSectionView()

      }
      .navigationTitle("PlaceSettings")
      .scrollDismissesKeyboard(.interactively)
    }
  }
}

#Preview {
  SettingsView()
    .environmentObject(SettingsHandler.defaults)
}
