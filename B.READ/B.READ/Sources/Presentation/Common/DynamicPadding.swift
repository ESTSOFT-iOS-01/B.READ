//
//  DynamicPadding.swift
//  B.READ
//
//  Created by 심근웅 on 6/13/25.
//

import Foundation
import SwiftUI

struct DynamicSize {
  static let baseWidth: CGFloat = 393
  static let baseHeight: CGFloat = 852
  static let baseDiagonal: CGFloat = sqrt(baseWidth * baseWidth + baseHeight * baseHeight)
  
  static var screenWidth: CGFloat {
    guard let windowScene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return 393
    }
    return windowScene.screen.bounds.width
  }
  
  static var screenHeight: CGFloat {
    guard let windowScene =
            UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return 852
    }
    return windowScene.screen.bounds.height
  }
  
  static var scaleFactor: CGFloat {
    let currentDiagonal = sqrt(screenWidth * screenWidth + screenHeight * screenHeight)
    return currentDiagonal / baseDiagonal
  }
  static func scaled(_ size: CGFloat) -> CGFloat {
    size * scaleFactor
  }
}

struct DynamicPaddingModifier: ViewModifier {
  let edge: Edge.Set
  let base: CGFloat
  
  func body(content: Content) -> some View {
    let adjusted = DynamicSize.scaled(base)
    content.padding(edge, adjusted)
  }
}

extension View {
  /// 화면 크기(대각선 기준)에 따라 패딩을 동적으로 조정
  func dynamicPadding(_ edge: Edge.Set = .all, _ base: CGFloat) -> some View {
    self.modifier(DynamicPaddingModifier(edge: edge, base: base))
  }
}
