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
      .frame(maxWidth: .infinity)
      .frame(height: 80)
      .font(.title3.bold())
      .background(.white)
      .clipShape(.capsule)
      .padding([.leading, .trailing])
      .padding(.bottom)
  }
}

struct OnboardingTitleModifier: ViewModifier {
  var bigger = false

  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .font(bigger ? .largeTitle.bold() : .title.bold())
      .foregroundStyle(.white)
      .padding([.leading, .trailing, .bottom])
  }
}

struct OnboardingTextModifier: ViewModifier {

  var smaller = false

  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .foregroundStyle(.white)
      .font(smaller ? .headline : .title3)
      .padding([.leading, .trailing, .bottom])
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
