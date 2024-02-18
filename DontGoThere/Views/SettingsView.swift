//
//  SettingsView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/14/24.
//

import SwiftUI

struct SettingsView: View {
  
  struct SettingsHeader: View {
    
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
  
  @EnvironmentObject var settings: AppSettings
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          HStack {
            Text("Never Expire:")
              .font(settings.neverExpire ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("Never Expire:", isOn: $settings.neverExpire)
              .labelsHidden()
          }
          
          if !settings.neverExpire {
            TimeValuePickerView(timeValue: $settings.autoExpiryValue, timeUnit: $settings.autoExpiryUnit, timeInterval: $settings.autoExpiryInterval, labelText: "SET TO EXPIRE IN:", pickerTitle: "Expiry Value")
          }
          
        } header: {
          SettingsHeader(headerTitle: "Expiration Settings", headerNote: "Set the default times to archive places from your active list.")
        } footer: {
          if settings.neverExpire {
            Text("Note: never expiring your active places may cause app data usage to increase over time.")
              .font(.headline)
          }
        }
        
        Section {
          HStack {
            Text("Never Delete")
              .font(settings.neverDelete ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("Never Delete:", isOn: $settings.neverDelete)
              .labelsHidden()
          }
          
          if !settings.neverDelete {
            TimeValuePickerView(timeValue: $settings.autoDeletionValue, timeUnit: $settings.autoDeletionUnit, timeInterval: $settings.autoDeletionInterval, labelText: "SET TO DELETE IN:", pickerTitle: "Deletion Value")
          }
        } header: {
          SettingsHeader(headerTitle: "Deletion Settings", headerNote: "Set the default time before archived places are automatically deleted.")
        } footer: {
          if settings.neverDelete {
            Text("Note: never deleting your archived places may cause app data usage to increase over time.")
              .font(.headline)
          }
        }
        
        Section {
          HStack {
            Text("No Limit")
              .font(settings.noNotificationLimit ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("No Limit", isOn: $settings.noNotificationLimit)
              .labelsHidden()
          }
          
          if !settings.noNotificationLimit {
            HStack {
              Text("NOTIFICATION LIMIT:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
              Picker("Notification Limit", selection: $settings.maxNotificationCount) {
                ForEach(1...30, id: \.self) { value in
                  Text(String(value))
                }
              }
              .pickerStyle(.wheel)
              .frame(height: 85)
            }
          }
        } header: {
          SettingsHeader(headerTitle: "Notification Settings", headerNote: "Set the max amount of times DontGoThere will remind you not to go to a place before archiving the place automatically.")
        }

      }
      .navigationTitle("DontGoThere Settings")
    }
  }
}

#Preview {
  SettingsView()
    .environmentObject(AppSettings.defaultSettings)
}
