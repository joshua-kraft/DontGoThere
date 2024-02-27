//
//  DontGoThereSearchIconView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/27/24.
//

import SwiftUI

struct DontGoThereSearchIconView: View {
  
  let width: CGFloat
  let height: CGFloat
  
  let borderColor = Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 1.0)
  
  var body: some View {
    ZStack {
      
      Circle()
        .fill(.orange)
        .frame(width: width, height: height)
      
      Image(systemName: "mappin.circle")
        .resizable()
        .background(.white)
        .foregroundStyle(.black)
        .frame(width: width / 2, height: height / 2)
        .clipShape(.circle)
    }
    .overlay(alignment: .trailing) {
      Image(systemName: "plus")
        .padding(.trailing, width / 10)
    }
    .overlay(alignment: .leading) {
      Image(systemName: "plus")
        .padding(.leading, width / 10)
    }
    .overlay(alignment: .top) {
      Image(systemName: "plus")
        .padding(.top, width / 10)
    }
    .overlay(alignment: .bottom) {
      Image(systemName: "plus")
        .padding(.bottom, width / 10)
    }
  }
}

#Preview {
  DontGoThereSearchIconView(width: 150, height: 150)
}
