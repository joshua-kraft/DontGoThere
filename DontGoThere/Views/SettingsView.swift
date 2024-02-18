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
  
  @EnvironmentObject var appSettings: AppSettings
  
  var body: some View {
    NavigationStack {
      Form {
        
         // Expiration Settings
        Section {
          HStack {
            Text("Never Expire:")
              .font(appSettings.neverExpire ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("Never Expire:", isOn: $appSettings.neverExpire)
              .labelsHidden()
          }
          
          if !appSettings.neverExpire {
            TimeValuePickerView(timeValue: $appSettings.autoExpiryValue, timeUnit: $appSettings.autoExpiryUnit, timeInterval: $appSettings.autoExpiryInterval, labelText: "SET TO EXPIRE IN:", pickerTitle: "Expiry Value")
          }
          
        } header: {
          SettingsHeader(headerTitle: "Expiration Settings", headerNote: "Set the default times to archive places from your active list.")
        } footer: {
          if appSettings.neverExpire {
            Text("Note: never expiring your active places may cause app data usage to increase over time.")
              .font(.headline)
          }
        }
        
        // Deletion Settings
        Section {
          HStack {
            Text("Never Delete")
              .font(appSettings.neverDelete ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("Never Delete:", isOn: $appSettings.neverDelete)
              .labelsHidden()
          }
          
          if !appSettings.neverDelete {
            TimeValuePickerView(timeValue: $appSettings.autoDeletionValue, timeUnit: $appSettings.autoDeletionUnit, timeInterval: $appSettings.autoDeletionInterval, labelText: "SET TO DELETE IN:", pickerTitle: "Deletion Value")
          }
        } header: {
          SettingsHeader(headerTitle: "Deletion Settings", headerNote: "Set the default time before archived places are automatically deleted.")
        } footer: {
          if appSettings.neverDelete {
            Text("Note: never deleting your archived places may cause app data usage to increase over time.")
              .font(.headline)
          }
        }
        
        // Notification Settings
        Section {
          HStack {
            Text("No Limit")
              .font(appSettings.noNotificationLimit ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("No Limit", isOn: $appSettings.noNotificationLimit)
              .labelsHidden()
          }
          
          if !appSettings.noNotificationLimit {
            HStack {
              Text("NOTIFICATION LIMIT:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
              Picker("Notification Limit", selection: $appSettings.maxNotificationCount) {
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
