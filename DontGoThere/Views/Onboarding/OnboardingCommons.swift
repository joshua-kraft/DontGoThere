//
//  OnboardingCommons.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import Foundation
import SwiftUI

struct OnboardingButton: View {

  var buttonTitle: String
  var adjustedHeight: CGFloat?

  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: adjustedHeight == nil ? nil : adjustedHeight! * 2, height: adjustedHeight ?? 80)
        .foregroundStyle(.white)
        .clipShape(.capsule)

      Text(buttonTitle)
        .font(.title3.bold())
        .foregroundStyle(.launch)
    }
  }
}

struct OnboardingBackButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .frame(width: 80, height: 40)
      .font(.title3.bold())
      .background(.white)
      .clipShape(.capsule)
      .padding(.leading)
  }
}

struct OnboardingForwardButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding([.top, .bottom])
      .padding(.leading, 40)
      .padding(.trailing, 40)
      .frame(height: 80)
      .font(.title3.bold())
      .background(.white)
      .clipShape(.capsule)
  }
}

struct OnboardingTitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .font(.largeTitle.bold())
      .foregroundStyle(.white)
      .padding([.leading, .trailing, .bottom])
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
