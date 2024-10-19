//
//  OnboardingView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

import SwiftUI

enum OnboardingPhase {
  case intro, location, notification, wrapup
}

struct OnboardingView: View {

  @State private var phase: OnboardingPhase = .intro

  var body: some View {
    switch phase {
    case .intro:
      OnboardingIntroView(phase: $phase)
    case .location:
      OnboardingLocationView(phase: $phase)
    case .notification:
      OnboardingNotificationView(phase: $phase)
    case .wrapup:
      OnboardingWrapupView(phase: $phase)
    }
  }
}

#Preview {
  OnboardingView()
}
