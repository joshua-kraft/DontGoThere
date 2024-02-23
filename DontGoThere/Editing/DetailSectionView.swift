//
//  DetailSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import SwiftUI

struct DetailSectionView: View {
  
  @Bindable var place: Place
  @EnvironmentObject var appSettings: AppSettings
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        DetailLabel("Name:")
          .padding([.leading])
        TextField("Place Name", text: $place.name)
          .textFieldStyle(.roundedBorder)
          .padding(.trailing)
      }
      .padding(.bottom, 4)
      HStack {
        DetailLabel("Added:")
          .padding([.leading])
        DatePicker("Added Date", selection: $place.addDate, displayedComponents: .date)
          .disabled(true)
          .labelsHidden()
        Spacer()
        DetailLabel("Expires?")
        Toggle("Expires?", isOn: $place.shouldExpire.animation())
          .labelsHidden()
          .padding(.trailing)
          .onChange(of: place.shouldExpire) {
            place.expirationDate = place.shouldExpire ? Date.distantFuture : appSettings.getExpiryDate(from: place.addDate)
          }
      }
      .padding(.bottom, 4)
      
      if place.shouldExpire {
        
        HStack {
          DetailLabel("Expires:")
            .padding([.leading])
          DatePicker("Expires", selection: $place.expirationDate, displayedComponents: .date)
            .labelsHidden()
        }
        .padding(.bottom, 4)
        
      }
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    
    return DetailSectionView(place: previewer.activePlace)
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
    
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
