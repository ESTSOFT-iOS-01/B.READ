//
//  RoundedCorner.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

#Preview {
  // 사용 예시
  Rectangle()
    .fill(Color.blue)
    .frame(width: 100, height: 100)
    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomRight]))
}
