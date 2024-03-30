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

        NavigationLink("Permissions Check") { }

        SettingsExpirationSectionView()

        SettingsDeletionSectionView()

        SettingsNotificationSectionView()

      }
      .navigationTitle("DontGoThere Settings")
      .scrollDismissesKeyboard(.interactively)
    }
  }
}

#Preview {
  SettingsView()
    .environmentObject(AppSettings.defaultSettings)
}
