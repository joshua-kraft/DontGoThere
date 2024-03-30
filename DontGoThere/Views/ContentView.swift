//
//  ContentView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/7/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {

  @AppStorage("onboardingComplete") var onboardingComplete: Bool = false

  var body: some View {
    if onboardingComplete {
      ApplicationTabsView()
    } else {
      OnboardingView()
    }
  }
}

#Preview {
  do {
    let previewer = try Previewer()
    return ContentView()
      .modelContainer(previewer.container)
      .environmentObject(LocationHandler.shared)
      .environmentObject(AppSettings.defaultSettings)
  } catch {
    return Text("Failed to create preview: \(error.localizedDescription)")
  }
}
