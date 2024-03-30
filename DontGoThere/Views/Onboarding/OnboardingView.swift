//
//  OnboardingView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

enum OnboardingPhase: String {
  case intro = "Intro"
  case locationPermission = "Location Permission"
  case notificationPermission = "Notification Permission"
  case finished = "Finished"
}

struct OnboardingView: View {

  @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false
  @State private var phase: OnboardingPhase = .intro

  var body: some View {
    switch phase {
    case .intro:
      OnboardingIntroView(phase: $phase)
    case .locationPermission:
      OnboardingLocationPermissionsView(phase: $phase)
    case .notificationPermission:
      Text("NotificationPermissionsView")
    case .finished:
      Text("OnboardingFinishedView")
    }
  }
}

#Preview {
  OnboardingView()
}
