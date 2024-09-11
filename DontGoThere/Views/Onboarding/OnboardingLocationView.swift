//
//  OnboardingLocationView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingLocationView: View {

  @Binding var phase: OnboardingPhase
  @State private var didRequestLocationAuth = false

  var body: some View {
    VStack {
      if didRequestLocationAuth {
        Spacer()

        Text("Great!")
          .modifier(OnboardingTitleModifier())

        Text("Tap the button below to review notifications.")
          .modifier(OnboardingTextModifier())

      } else {
        Text("Location Permissions")
          .modifier(OnboardingTitleModifier())

        ScrollView(.vertical) {
          VStack {
            Text("DontGoThere shows you your current location on the PlaceMap.")
              .modifier(OnboardingTextModifier())

            Text("When you add a new place, it is added at your current location by default.")
              .modifier(OnboardingTextModifier())

            Text("DontGoThere also watches your location to notify you if you approach a place.")
              .modifier(OnboardingTextModifier())

            Text("To do this, DontGoThere needs permission to access your location data through Location Services.")
              .modifier(OnboardingTextModifier())

            Text("DontGoThere never keeps any data related to your location.")
              .modifier(OnboardingTextModifier())

            Text("If you prefer not to grant location permission, you can still use DontGoThere with the PlaceMap.")
              .modifier(OnboardingTextModifier())

            Text("Tap the button below to grant or deny DontGoThere permission to use your location.")
              .modifier(OnboardingTextModifier())
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        Spacer()
      }

      if didRequestLocationAuth {
        Button("Next: Notification Permission") {
          withAnimation(.default.speed(0.33)) {
            phase = .notification
          }
        }
        .modifier(OnboardingForwardButtonModifier())
      } else {
        Button("Grant Location Permission") {
          LocationHandler.shared.startup()
          withAnimation(.default.speed(0.67)) {
            didRequestLocationAuth = true
          }
        }
        .modifier(OnboardingForwardButtonModifier())
      }
    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingLocationView(phase: .constant(.location))
}
