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

        Spacer()
      }
      
      Text("Location Permissions")
        .modifier(OnboardingTitleModifier())

      Spacer()

      Text("DontGoThere shows you your current location on the PlaceMap.")
        .modifier(OnboardingTextModifier())

      Text("When you add a new place, it is added at your current location by default.")
        .modifier(OnboardingTextModifier())

      Text("DontGoThere also watches your location in the background in order to notify you as you approach a place you've added.")
        .modifier(OnboardingTextModifier())

      Text("To do this, DontGoThere needs permission to access your location data through Location Services.")
        .modifier(OnboardingTextModifier(smaller: true))

      Text("DontGoThere never keeps any data related to your location.")
        .modifier(OnboardingTextModifier(smaller: true))

      Spacer()

      Button("Grant Location Permission") {
        LocationHandler.shared.startup()
        didRequestLocationAuth = true
      }
      .modifier(OnboardingForwardButtonModifier())
      .disabled(didRequestLocationAuth)

      Button("Next: Notification Permission") {
        withAnimation {
          phase = .notificationPermission
        }
      }
      .modifier(OnboardingForwardButtonModifier())
      .disabled(!didRequestLocationAuth)

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingLocationPermissionsView(phase: .constant(.locationPermission))
}
