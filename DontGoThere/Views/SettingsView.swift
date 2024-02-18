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
  @State private var neverExpire = false
  @State private var autoExpiryValue = 1
  @State private var autoExpiryUnit = TimeUnit.months
  @State private var autoExpiryInterval = 0.0
  
  @State private var neverDelete = false
  @State private var autoDeletionValue = 1
  @State private var autoDeletionUnit = TimeUnit.months
  @State private var autoDeletionInterval = 0.0
  
  @State private var maxNotificationCount = 10
  @State private var noNotificationLimit = false
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          HStack {
            Text("Never Expire:")
              .font(neverExpire ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("Never Expire:", isOn: $neverExpire)
              .labelsHidden()
          }
          
          if !neverExpire {
            TimeValuePickerView(timeValue: $autoExpiryValue, timeUnit: $autoExpiryUnit, timeInterval: $autoExpiryInterval, labelText: "SET TO EXPIRE IN:", pickerTitle: "Expiry Value")
          }
          
        } header: {
          SettingsHeader(headerTitle: "Expiration Settings", headerNote: "Set the default times to archive places from your active list.")
        }
        
        Section {
          HStack {
            Text("Never Delete")
              .font(neverDelete ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("Never Delete:", isOn: $neverDelete)
              .labelsHidden()
          }
          
          if !neverDelete {
            TimeValuePickerView(timeValue: $autoDeletionValue, timeUnit: $autoDeletionUnit, timeInterval: $autoDeletionInterval, labelText: "SET TO DELETE IN:", pickerTitle: "Deletion Value")
          }
        } header: {
          SettingsHeader(headerTitle: "Deletion Settings", headerNote: "Set the default time before archived places are automatically deleted.")
        }
        
        Section {
          HStack {
            Text("No Limit")
              .font(noNotificationLimit ? .subheadline.bold() : .subheadline)
            Spacer()
            Toggle("No Limit", isOn: $noNotificationLimit)
              .labelsHidden()
          }
          
          if !noNotificationLimit {
            HStack {
              Text("NOTIFICATION LIMIT:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
              Picker("Notification Limit", selection: $maxNotificationCount) {
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
}
