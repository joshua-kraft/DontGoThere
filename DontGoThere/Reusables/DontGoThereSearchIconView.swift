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
      
      Circle()
        .fill(.blue)
        .frame(width: width * 0.9, height: height * 0.9)
      
      Image(systemName: "mappin.and.ellipse")
        .resizable()
      //          .background(.white)
        .foregroundStyle(.black)
        .frame(width: width / 2, height: height / 2)
      //          .clipShape(.circle)
      
      Image(systemName: "plus")
        .resizable()
        .foregroundStyle(.white)
        .frame(width: width * 0.2, height: height * 0.2)
        .padding(.leading, width * 0.5)
        .padding(.bottom, height * 0.3)
    }
  }
}

#Preview {
  DontGoThereSearchIconView(width: 50, height: 50)
}