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
  let borderColor = Color(red: 0.15, green: 0.15, blue: 0.15, opacity: 1.0)

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
        .stroke(borderColor.gradient, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        .fill(.yellow.gradient.shadow(.drop(radius: 15)))
        .frame(width: width, height: height)

      Image(.turnAroundIcon)
        .resizable()
        .foregroundStyle(.black.gradient)
        .frame(width: width / 2.5, height: width / 2.5)
        .padding(.top, height / 10)
        .padding(.leading, width / 25)
    }
  }

  init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }
}

struct DontGoThereUnavailableLabel: View {
  let titleText: String

  var body: some View {
    Label(
      title: { Text(titleText) },
      icon: { DontGoThereIconView(width: 180, height: 144) }
    )
  }

  init(_ titleText: String) {
    self.titleText = titleText
  }
}

#Preview {
    DontGoThereIconView(width: 180, height: 144)
}
