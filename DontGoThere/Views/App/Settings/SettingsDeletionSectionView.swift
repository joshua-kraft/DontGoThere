//
//  SettingsDeletionSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct SettingsDeletionSectionView: View {

  @EnvironmentObject var appSettings: AppSettings

  var body: some View {
    // Deletion Settings
    Section {
      HStack {
        Text("Never Delete:")
          .font(appSettings.neverDelete ? .subheadline.bold() : .subheadline)
        Spacer()
        Toggle("Never Delete:", isOn: $appSettings.neverDelete.animation())
          .labelsHidden()
      }

      if !appSettings.neverDelete {
        HStack {
          Text("Set to Delete In:")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.leading)

          Spacer()

          Picker("Deletion Value", selection: $appSettings.autoDeletionValue) {
            ForEach(1...100, id: \.self) { value in
              Text(String(value))
            }
          }
          .labelsHidden()
          .pickerStyle(.wheel)
          .frame(height: 85)

          Spacer()

          Picker("Deletion Unit", selection: $appSettings.autoDeletionUnit) {
            ForEach(TimeUnit.allCases, id: \.self) { unit in
              Text(unit.rawValue)
            }
          }
          .labelsHidden()
        }
        .padding(.bottom, 4)
      }
    } header: {
      SettingsHeaderView(headerTitle: "Deletion Settings",
                         headerNote: "Set the default time before archived places are automatically deleted.")
    } footer: {
      if appSettings.neverDelete {
        Text("Note: never deleting your archived places may cause app storage usage to increase over time.")
          .font(.headline)
      }
    }
  }
}

#Preview {
  SettingsDeletionSectionView()
    .environmentObject(AppSettings.defaultSettings)
}
