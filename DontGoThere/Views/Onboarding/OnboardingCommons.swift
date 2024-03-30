//
//  OnboardingCommons.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import Foundation
import SwiftUI

struct OnboardingContinueButton: View {
  var body: some View {
    ZStack {
      Rectangle()
        .frame(height: 80)
        .foregroundStyle(.white)
        .clipShape(.capsule)
        .padding()

      Text("Continue")
        .font(.title2.bold())
        .foregroundStyle(.launch)
    }
  }
}

struct OnboardingTitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .font(.largeTitle.bold())
      .foregroundStyle(.white)
      .padding()
  }
}

struct OnboardingTextModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .foregroundStyle(.white)
      .font(.title3)
      .padding()
  }
}

struct OnboardingBackgroundGradient: View {
  var body: some View {
    LinearGradient(stops: [
      .init(color: .darkenedLaunch, location: 0.20),
      .init(color: .launch, location: 0.80),
      .init(color: .darkenedLaunch, location: 1.0)
    ], startPoint: .top, endPoint: .bottom)
    .ignoresSafeArea()
  }
}
