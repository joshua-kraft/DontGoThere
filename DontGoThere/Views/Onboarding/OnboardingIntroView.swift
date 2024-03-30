//
//  OnboardingIntroView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingIntroView: View {

  @Binding var phase: OnboardingPhase

  var body: some View {
    VStack {
      Text("Welcome to DontGoThere")
        .modifier(OnboardingTitleModifier())

      Spacer()

      Text("DontGoThere helps you keep track of the places you've been where you don't want to be again.")
        .modifier(OnboardingTextModifier())

      Text("You add places where you've had poor experiences. The next time you go, DontGoThere reminds you not to.")
        .modifier(OnboardingTextModifier())

      Text("The next screens will go through a series of permission requests for your location and notifications.")
        .modifier(OnboardingTextModifier())

      Text("DontGoThere does not keep any information about your location or how you use the application.")
        .modifier(OnboardingTextModifier())

      Spacer()

      Button("Next: Location Permission") {
        withAnimation {
          phase = .locationPermission
        }
      }
      .modifier(OnboardingForwardButtonModifier())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingIntroView(phase: .constant(.intro))
}
