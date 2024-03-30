//
//  OnboardingView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingView: View {

  @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false

  var body: some View {
    NavigationStack {
      VStack {
        Text("Welcome to DontGoThere")
          .modifier(OnboardingTitleModifier())

        Spacer()

        Text("DontGoThere helps you keep track of the places you've been where you don't want to be again.")
          .modifier(OnboardingTextModifier())

        Text("You add places as you have poor experiences. The next time you approach, DontGoThere reminds you not to.")
          .modifier(OnboardingTextModifier())

        Text("The next screens will go through a series of permission requests for your location and notifications.")
          .modifier(OnboardingTextModifier())

        Text("DontGoThere does not keep any information about your location or how you use the application.")
          .modifier(OnboardingTextModifier())

        Spacer()

        NavigationLink {
          OnboardingLocationPermissionsView()
        } label: {
          OnboardingContinueButton()
        }


      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(LaunchBackgroundGradient())
    }
  }
}

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

struct LaunchBackgroundGradient: View {
  var body: some View {
    LinearGradient(stops: [
      .init(color: .darkenedLaunch, location: 0.20),
      .init(color: .launch, location: 0.80),
      .init(color: .darkenedLaunch, location: 1.0)
    ], startPoint: .top, endPoint: .bottom)
    .ignoresSafeArea()
  }
}

#Preview {
  OnboardingView()
}
