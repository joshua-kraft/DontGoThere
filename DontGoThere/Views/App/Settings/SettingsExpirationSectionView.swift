//
//  SettingsExpirationSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct SettingsExpirationSectionView: View {

  @EnvironmentObject var appSettings: AppSettings

  var body: some View {
    Section {
      HStack {
        Text("Never Expire:")
          .font(appSettings.neverExpire ? .subheadline.bold() : .subheadline)
        Spacer()
        Toggle("Never Expire:", isOn: $appSettings.neverExpire.animation())
          .labelsHidden()
      }

      if !appSettings.neverExpire {
        HStack {
          Text("Set to Expire in:")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.leading)

          Spacer()

          Picker("Expiry Value", selection: $appSettings.autoExpiryValue) {
            ForEach(1...100, id: \.self) { value in
              Text(String(value))
            }
          }
          .labelsHidden()
          .pickerStyle(.wheel)
          .frame(height: 85)

          Spacer()

          Picker("Expiry Unit", selection: $appSettings.autoExpiryUnit) {
            ForEach(TimeUnit.allCases, id: \.self) { unit in
              Text(unit.rawValue)
            }
          }
          .labelsHidden()
        }
        .padding(.bottom, 4)
      }

    } header: {
      SettingsHeaderView(headerTitle: "Expiration Settings",
                         headerNote: "Set the default times to archive places from your active list.")
    } footer: {
      if appSettings.neverExpire {
        Text("Note: never expiring your active places may cause app storage usage to increase over time.")
          .font(.headline)
      }
    }
  }
}

#Preview {
  SettingsExpirationSectionView()
    .environmentObject(AppSettings.defaultSettings)
}
