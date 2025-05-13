//
//  Font.swift
//  TikiTalka
//
//  Created by 신승재 on 4/27/25.
//

import Foundation
import SwiftUI

extension UIFont {
  enum Pretendard: String {
    case black = "Pretendard-Black"
    case extraBold = "Pretendard-ExtraBold"
    case bold = "Pretendard-Bold"
    case semiBold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case light = "Pretendard-Light"
    case extraLight = "Pretendard-ExtraLight"
    case thin = "Pretendard-Thin"
  }
  
  /// Pretendard 커스텀 폰트를 반환합니다.
  /// - Parameters:
  ///   - weight: Pretendard enum
  ///   - size: 폰트 크기
  /// - Returns: UIFont 인스턴스
  static func pretendard(_ weight: Pretendard, size: CGFloat) -> UIFont {
    return UIFont(name: weight.rawValue, size: size)!
  }
  
  /// PeaceSans 커스텀 폰트를 반환합니다.
  /// - Parameter size: 폰트 크기
  /// - Returns: UIFont 인스턴스
  static func peaceSans(size: CGFloat) -> UIFont {
    return UIFont(name: "PeaceSans", size: size)!
  }
}
