//
//  DontGoThereIconView.swift
//  DontGoThere
//
//  Created by Joshua Kraft on 2/21/24.
//  Copyright © 2024 Joshua Kraft. All rights reserved.

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
        .stroke(.iconBorder.gradient, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        .fill(.yellow.gradient.shadow(.drop(radius: 15)))
        .frame(width: width, height: height)

      Image(.turnAroundIcon)
        .resizable()
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

struct DontGoThereMapButtonLabel: View {

  var body: some View {
    ZStack {
      Circle()
        .fill(.iconBackground.gradient)
      DontGoThereIconView(width: 25, height: 20)
        .padding(.top, 7)
    }
    .frame(width: 45, height: 45)
  }
}

#Preview {
  DontGoThereMapButtonLabel()
}
