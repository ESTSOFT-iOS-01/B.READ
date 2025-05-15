//
//  RoundedBackgroundModifier.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

struct RoundedBackgroundModifier: ViewModifier {
  var color: Color
  var cornerRadius: CGFloat
  
  func body(content: Content) -> some View {
    content
      .background(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(color)
      )
  }
}

extension View {
  func roundedBackground(color: Color = .gray0, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(RoundedBackgroundModifier(color: color, cornerRadius: cornerRadius))
    }
}
