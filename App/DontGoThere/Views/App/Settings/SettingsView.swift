//
//  SettingsView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/14/24.
//

import SwiftUI

struct SettingsView: View {

  @EnvironmentObject var appSettings: AppSettings

  var body: some View {
    NavigationStack {
      Form {

        NavigationLink("Privacy Statement") { PrivacyStatementView() }

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
    .environmentObject(AppSettings.defaultSettings)
}