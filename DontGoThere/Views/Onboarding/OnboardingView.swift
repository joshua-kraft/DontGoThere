//
//  OnboardingView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

enum OnboardingPhase {
  case intro, locationPermission, notificationPermission, wrapup
}

struct OnboardingView: View {

  @State private var phase: OnboardingPhase = .intro

  var body: some View {
    switch phase {
    case .intro:
      OnboardingIntroView(phase: $phase)
    case .locationPermission:
      OnboardingLocationPermissionsView(phase: $phase)
    case .notificationPermission:
      OnboardingNotificationPermissionView(phase: $phase)
    case .wrapup:
      OnboardingWrapupView(phase: $phase)
    }
  }
}

#Preview {
  OnboardingView()
}
