//
//  DontGoThereIconView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/21/24.
//

import SwiftUI

struct DontGoThereIconView: View {
  
  let width: CGFloat
  let height: CGFloat
  
  struct InvertedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
      var path = Path()
      path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
      return path
    }
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      InvertedTriangle()
        .stroke(.black, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        .fill(.yellow)
        .frame(width: width, height: height)
      
      Image(systemName: "mappin.slash.circle")
        .resizable()
        .background(.white)
        .foregroundStyle(.black)
        .frame(width: width / 2, height: width / 2)
        .clipShape(.circle)
        .padding(.top, 2)
    }
  }
  
  init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }
  
}

#Preview {
    DontGoThereIconView(width: 60, height: 48)
}
