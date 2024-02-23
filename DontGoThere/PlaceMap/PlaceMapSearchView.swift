//
//  PlaceMapSearchView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/23/24.
//

import MapKit
import SwiftUI

struct PlaceMapSearchView: View {
  
  @State private var searchText = ""
  
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
        TextField("Search for a place...", text: $searchText)
          .autocorrectionDisabled()
          .padding(12)
          .background(.gray.opacity(0.2))
          .clipShape(.rect(cornerRadius: 8))
          .foregroundStyle(.primary)
      }
      
      Spacer()
      
    }
    .padding()
    .presentationDetents([.height(150), .large])
    .presentationBackground(.regularMaterial)
    .presentationBackgroundInteraction(.enabled(upThrough: .large))
  }
}

#Preview {
  PlaceMapSearchView()
}
