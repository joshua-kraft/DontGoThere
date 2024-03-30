//
//  OnboardingNotificationPermissionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingNotificationPermissionView: View {

  @Binding var phase: OnboardingPhase
  @AppStorage("didRequestNotificationAuth") private var didRequestNotificationAuth = false

  var body: some View {
    ScrollView(.vertical) {
      VStack {
        HStack {
          Button("Back") {
            withAnimation {
              phase = .locationPermission
            }
          }
          .modifier(OnboardingBackButtonModifier())

          Spacer()
        }

        Text("Notification Permission")
          .modifier(OnboardingTitleModifier())

        Spacer()

        Text("DontGoThere will send you notifications if you get close enough to a place you added.")
          .modifier(OnboardingTextModifier())

        Text("You set the radius to be notified within when you create the place.")
          .modifier(OnboardingTextModifier())

        Text("It will only send one notification per place visited per day.")
          .modifier(OnboardingTextModifier())

        Text("You can set the maximum amount of notifications allowed for a place.")
          .modifier(OnboardingTextModifier())

        Text("To do this, DontGoThere needs your permission to send notifications.")
          .modifier(OnboardingTextModifier())

        Spacer()

        Button("Grant Notification Permission") {
          NotificationHandler.shared.requestNotificationPermissions()
          didRequestNotificationAuth = true
        }
        .modifier(OnboardingForwardButtonModifier())
        .disabled(didRequestNotificationAuth)

        Button("Next: Wrap-Up") {
          withAnimation {
            phase = .finished
          }
        }
        .modifier(OnboardingForwardButtonModifier())
        .disabled(!didRequestNotificationAuth)

      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingNotificationPermissionView(phase: .constant(.notificationPermission))
}
