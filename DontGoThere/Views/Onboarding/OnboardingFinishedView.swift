//
//  OnboardingFinished.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 3/30/24.
//

import SwiftUI

struct OnboardingFinishedView: View {

  @Binding var phase: OnboardingPhase
  @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false

  var body: some View {
    ScrollView(.vertical) {
      VStack {
        HStack {
          Button("Back") {
            withAnimation {
              phase = .notificationPermission
            }
          }
          .modifier(OnboardingBackButtonModifier())
          Spacer()
        }

        Text("You're all set!")
          .modifier(OnboardingTitleModifier(bigger: true))

        Spacer()

        Text("Shortly you'll be able to add your first place.")
          .modifier(OnboardingTextModifier())

        Text("Places have a name, location, address, expiration date, review, and photos.")
          .modifier(OnboardingTextModifier())

        Text("When you add a place, you can configure the notification radius and the maximum notifications allowed.")
          .modifier(OnboardingTextModifier())

        Text("Changes to the map location of a place will update the address, and vice versa.")
          .modifier(OnboardingTextModifier())

        Text("Add a place with the Add Button (+), tap anywhere on the PlaceMap, or search for a place to add.")
          .modifier(OnboardingTextModifier())

        Spacer()

        Button("Finished!") {
          withAnimation {
            onboardingComplete = true
          }
        }
        .modifier(OnboardingForwardButtonModifier())
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingFinishedView(phase: .constant(.finished))
}
