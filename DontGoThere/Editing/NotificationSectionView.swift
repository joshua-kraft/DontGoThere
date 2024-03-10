//
//  NotificationSectionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/10/24.
//

import SwiftUI

struct NotificationSectionView: View {

  @Bindable var place: Place
  @EnvironmentObject var appSettings: AppSettings
  @FocusState private var focusedField: Field?

  enum Field {
    case distanceField
  }

  var body: some View {
    VStack(alignment: .leading) {
      HeaderLabel("Notifications")
        .padding(.leading)

      HStack {
        DetailLabel("Notification Distance:")
          .padding([.leading])

        Spacer()

        TextField("Distance", value: $place.radius, format: .number)
          .multilineTextAlignment(.trailing)
          .textFieldStyle(.roundedBorder)
          .keyboardType(.numberPad)
          .frame(width: 75)
          .padding(.trailing, 6)
          .focused($focusedField, equals: .distanceField)
          .onChange(of: focusedField) {
            if focusedField == .distanceField {
              Task {
                UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
              }
            }
          }

        Text("Meters")
          .padding([.trailing])
      }
      .padding(.bottom, 4)

      HStack {
        DetailLabel("Max Notification Count:")
          .padding([.leading])
        Spacer()
        Text(String(appSettings.maxNotificationCount))
          .padding([.trailing])
        Stepper("Notification Count", value: $place.maxNotificationCount, in: 1...30)
          .labelsHidden()
      }
      .padding(.bottom, 4)
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return NotificationSectionView(place: previewer.activePlace)
      .modelContainer(previewer.container)
      .environmentObject(AppSettings.defaultSettings)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
