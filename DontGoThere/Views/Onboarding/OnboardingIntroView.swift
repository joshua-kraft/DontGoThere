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
      Text("Welcome to DontGoThere!")
        .modifier(OnboardingTitleModifier(bigger: true))
        .padding()

      ScrollView(.vertical) {
        VStack {
          Text("DontGoThere helps you keep track of the places you've been where you don't want to be again.")
            .modifier(OnboardingTextModifier())

          Text("You add places where you've had poor experiences, but it can be hard to keep track.")
            .modifier(OnboardingTextModifier())

          Text("If you forget, the next time you go, DontGoThere reminds you not to.")
            .modifier(OnboardingTextModifier())

          Text("The next screens will go through a series of permission requests for your location and notifications.")
            .modifier(OnboardingTextModifier())

          Text("DontGoThere does not keep any information about your location or how you use the application.")
            .modifier(OnboardingTextModifier())

          Text("Tap the button below to review location permissions.")
            .modifier(OnboardingTextModifier())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      Spacer()

      Button("Next: Location Permission") {
        withAnimation(.default.speed(0.33)) {
          phase = .location
        }
      }
      .modifier(OnboardingForwardButtonModifier())

    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingIntroView(phase: .constant(.intro))
}
