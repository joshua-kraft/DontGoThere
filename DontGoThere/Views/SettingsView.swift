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
  
  @AppStorage("autoExpireInterval") var autoExpireInterval = 0
  @AppStorage("neverExpirePlaces") var neverExpire = false
  @AppStorage("autoDeleteInterval") var autoDeleteInterval = 0
  @AppStorage("neverDeletePlaces") var neverDelete = false
  @AppStorage("maxNotificationCount") var maxNotificationCount = 0
  
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
              .listRowInsets(EdgeInsets())
              .padding([.top, .bottom])
          }
          
        } header: {
          SettingsHeader(headerTitle: "Expiration Settings", headerNote: "Set the default times to archive places from your active list.")
        }
        
        Section {
          
        } header: {
          SettingsHeader(headerTitle: "Deletion Settings", headerNote: "Set the default time before archived places are automatically deleted.")
        }
        
        Section {
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
