//
//  SettingsNotificationSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct SettingsNotificationSectionView: View {

  @EnvironmentObject var appSettings: AppSettings
  @FocusState var isDistanceFieldFocused

  var body: some View {
    // Notification Settings
    Section {
      HStack {
        Text("No Limit:")
          .font(appSettings.noNotificationLimit ? .subheadline.bold() : .subheadline)
        Spacer()
        Toggle("No Limit:", isOn: $appSettings.noNotificationLimit.animation())
          .labelsHidden()
      }

      if !appSettings.noNotificationLimit {
        HStack {
          Text("Notification Limit:")
            .font(.subheadline)
            .foregroundStyle(.secondary)
          Picker("Notification Limit:", selection: $appSettings.maxNotificationCount) {
            ForEach(1...30, id: \.self) { value in
              Text(String(value))
            }
          }
          .pickerStyle(.wheel)
          .frame(height: 85)
        }
      }

      HStack {
        Text("Distance: ")
          .font(.subheadline)
          .foregroundStyle(.secondary)
        Spacer()
        TextField("Distance", value: $appSettings.regionRadius, format: .number)
          .frame(width: 100)
          .multilineTextAlignment(.trailing)
          .keyboardType(.numberPad)
          .textFieldStyle(.roundedBorder)
          .focused($isDistanceFieldFocused)
          .onChange(of: isDistanceFieldFocused) {
            if isDistanceFieldFocused {
              Task {
                UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
              }
            }
          }
        Text("Meters")
      }
    } header: {
      SettingsHeaderView(headerTitle: "Notification Settings",
                         headerNote: "Set the amount of times DontGoThere will remind you not to go to a place, "
                         + "and how close you need to be before the notification. "
                         + "The place is archived after the limit is reached.")
    }
  }
}

#Preview {
  SettingsNotificationSectionView()
    .environmentObject(AppSettings.defaultSettings)
}
