//
//  OnboardingLocationPermissionsView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingLocationPermissionsView: View {

  @Binding var phase: OnboardingPhase
  @AppStorage("didRequestLocationAuth") private var didRequestLocationAuth = false

  var body: some View {
    VStack {
      HStack {
        Button("Back") {
          withAnimation {
            phase = .intro
          }
        }
        .modifier(OnboardingBackButtonModifier())
        .padding(4)

        Spacer()
      }

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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      Spacer()

      if didRequestLocationAuth {
        Button("Next: Notification Permission") {
          withAnimation {
            phase = .notificationPermission
          }
        }
        .modifier(OnboardingForwardButtonModifier())
        .disabled(!didRequestLocationAuth)
      } else {
        Button("Grant Location Permission") {
          LocationHandler.shared.startup()
          didRequestLocationAuth = true
        }
        .modifier(OnboardingForwardButtonModifier())
        .disabled(didRequestLocationAuth)
      }
    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingLocationPermissionsView(phase: .constant(.locationPermission))
}
