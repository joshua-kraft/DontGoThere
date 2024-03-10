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
  
  @FocusState var isDistanceFieldFocused
  
  var body: some View {
    NavigationStack {
      Form {
        
         // Expiration Settings
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
          SettingsHeader(headerTitle: "Expiration Settings", headerNote: "Set the default times to archive places from your active list.")
        } footer: {
          if appSettings.neverExpire {
            Text("Note: never expiring your active places may cause app storage usage to increase over time.")
              .font(.headline)
          }
        }
        
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
          SettingsHeader(headerTitle: "Deletion Settings", headerNote: "Set the default time before archived places are automatically deleted.")
        } footer: {
          if appSettings.neverDelete {
            Text("Note: never deleting your archived places may cause app storage usage to increase over time.")
              .font(.headline)
          }
        }
        
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
            TextField("Distance in Meters", value: $appSettings.regionRadius, format: .number)
              .keyboardType(.numberPad)
              .textFieldStyle(.roundedBorder)
              .multilineTextAlignment(.trailing)
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
          SettingsHeader(headerTitle: "Notification Settings", headerNote: "Set the max amount of times DontGoThere will remind you not to go to a place before archiving the place automatically, as well as how close you need to be before DontGoThere will send you a notification.")
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
