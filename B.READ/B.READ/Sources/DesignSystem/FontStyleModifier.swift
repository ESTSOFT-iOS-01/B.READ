//
//  FontWithLineHeight.swift
//  B.READ
//
//  Created by 신승재 on 5/13/25.
//

import SwiftUI

struct FontStyleModifier: ViewModifier {
  let font: UIFont
  let lineHeight: CGFloat
  let letterSpacing: CGFloat

  func body(content: Content) -> some View {
    
    let fontSpacing = font.lineHeight / 78 * 50 / 4

    return content
      .font(Font(font))
      .padding(.vertical, fontSpacing)
      .lineSpacing(fontSpacing * 2)
      .tracking(font.pointSize * letterSpacing)
  }
}

extension View {
  /// BR 스타일 폰트 적용 (줄간격 및 자간 설정)
  /// - Parameters:
  ///   - font: 사용할 UIFont
  ///   - lineHeight: 줄간격 배수 (예: 1.4 → 140%)
  ///   - letterSpacing: 자간 배수 (예: 0.02 → 2%)
  func brStyleFont(
    _ font: UIFont,
    lineHeight: CGFloat,
    letterSpacing: CGFloat = 0.0
  ) -> some View {
    self.modifier(FontStyleModifier(
      font: font,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing
    ))
  }
}
