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
  
  @AppStorage("autoExpireInterval") var autoExpireInterval = 0.0
  @AppStorage("neverExpirePlaces") var neverExpire = false
  @AppStorage("autoDeleteInterval") var autoDeleteInterval = 0.0
  @AppStorage("neverDeletePlaces") var neverDelete = false
  @AppStorage("maxNotificationCount") var maxNotificationCount = 10
  @AppStorage("noNotificationLimit") var noNotificationLimit = false
  
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
            TimeValuePickerView(timeIntervalValue: $autoExpireInterval, labelText: "SET TO EXPIRE IN:", pickerTitle: "Expiry Time")
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
            TimeValuePickerView(timeIntervalValue: $autoDeleteInterval, labelText: "SET TO DELETE IN:", pickerTitle: "Deletion Time")
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
              .listRowInsets(EdgeInsets())
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
