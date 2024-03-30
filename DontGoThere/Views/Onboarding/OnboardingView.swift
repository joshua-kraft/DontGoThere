//
//  OnboardingView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("DontGoThere")
          .font(.largeTitle.bold())
          .foregroundStyle(.white.gradient)

        Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background {
        LinearGradient(stops: [
          .init(color: .darkenedLaunch, location: 0.20),
          .init(color: .launch, location: 0.80),
          .init(color: .darkenedLaunch, location: 1.0)
        ], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
      }
    }
  }
}

#Preview {
  OnboardingView()
}
