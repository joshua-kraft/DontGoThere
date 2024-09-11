//
//  OnboardingNotificationPermissionView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingNotificationPermissionView: View {

  @Binding var phase: OnboardingPhase
  @State private var didRequestNotificationAuth = false

  var body: some View {
    VStack {
      if didRequestNotificationAuth {
        Spacer()

        Text("Great!")
          .modifier(OnboardingTitleModifier())

        Text("Tap the button below to wrap-up.")
          .modifier(OnboardingTextModifier())

      } else {
        Text("Notification Permission")
          .modifier(OnboardingTitleModifier())

        ScrollView(.vertical) {
          VStack {
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

            Text("You can use DontGoThere without notifications. You won't be notified as you approach added places.")
              .modifier(OnboardingTextModifier())

            Text("Tap the button below to grant or deny DontGoThere permission to send notifications.")
              .modifier(OnboardingTextModifier())
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        Spacer()
      }

      if didRequestNotificationAuth {
        Button("Next: Wrap-Up") {
          withAnimation(.default.speed(0.33)) {
            phase = .wrapup
          }
        }
        .modifier(OnboardingForwardButtonModifier())
        .disabled(!didRequestNotificationAuth)
      } else {
        Button("Grant Notification Permission") {
          NotificationHandler.shared.requestNotificationPermissions()
          withAnimation(.default.speed(0.67)) {
            didRequestNotificationAuth = true
          }
        }
        .modifier(OnboardingForwardButtonModifier())
        .disabled(didRequestNotificationAuth)
      }
    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingNotificationPermissionView(phase: .constant(.notificationPermission))
}
