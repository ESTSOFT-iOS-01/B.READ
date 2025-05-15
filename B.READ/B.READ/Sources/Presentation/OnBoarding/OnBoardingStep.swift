//
//  OnBoardingStep.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import Foundation
import SwiftUI

enum OnboardingStep: Int, CaseIterable {
  case guide = 0
  case read
  case connect
  case assistant
  
  var title: String {
    switch self {
    case .guide:
      "Guide"
    case .read:
      "Read"
    case .connect:
      "Connect"
    case .assistant:
      "Assistant"
    }
  }
  
  var content: String {
    switch self {
    case .guide:
      """
      책장을 넘기는 순간부터,
      당신의 책방은 시작됩니다.
      천천히 읽고, 깊게 머무르며,
      당신만의 속도로 책방을 채워보세요.
      """
    case .read:
      """
      책을 읽다가 생각이 떠오르면
      언제든지 기록해보세요.
      작은 조각들을 모아 당신만의
      향긋한 책방을 꾸려보세요.
      """
    case .connect:
      """
      당신의 생각을 남기고,
      책을 함께 읽는 감동을 느껴보세요.
      나의 생각이
      누군가의 다음 책장이 될 수 있어요.
      """
    case .assistant:
      """
      책에 남긴 문장과 메모,
      빵식이가 정리해두었어요.
      따뜻하게 담아낸 기록,
      하루를 마무리하며 꺼내보세요.
      """
    }
  }
  
  var image: Image {
    switch self {
    case .guide:
      Image(.guideBread)
    case .read:
      Image(.readBread)
    case .connect:
      Image(.connectBread)
    case .assistant:
      Image(.assistantBread)
    }
  }
}
