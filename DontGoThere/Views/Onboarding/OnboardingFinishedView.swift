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
    VStack {
      HStack {
        Button("Back") {
          withAnimation {
            phase = .notificationPermission
          }
        }
        .modifier(OnboardingBackButtonModifier())
        .padding(4)

        Spacer()
      }

      Text("You're all set!")
        .modifier(OnboardingTitleModifier(bigger: true))

      ScrollView(.vertical) {
        VStack {
          Text("Add and avoid the places you've been where you don't want to be again.")
            .modifier(OnboardingTextModifier())

          Text("Places have a name, location, address, expiration date, review, and photos.")
            .modifier(OnboardingTextModifier())

          Text("When you add a place, you can configure the notification radius and the maximum notifications allowed.")
            .modifier(OnboardingTextModifier())

          Text("Changes to the map location of a place will update the address, and vice versa.")
            .modifier(OnboardingTextModifier())

          Text("Add a place with the Add Button (+), tap anywhere on the PlaceMap, or search for a place to add.")
            .modifier(OnboardingTextModifier())

          Text("Use the PlaceSettings to change default expiry/archival time, notification counts, and alert radius.")
            .modifier(OnboardingTextModifier())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      Spacer()

      Button("Finished!") {
        withAnimation {
          onboardingComplete = true
        }
      }
      .modifier(OnboardingForwardButtonModifier())
    }
    .background(OnboardingBackgroundGradient())
  }
}

#Preview {
  OnboardingFinishedView(phase: .constant(.finished))
}
