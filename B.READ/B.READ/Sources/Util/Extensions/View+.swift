//
//  View+.swift
//  B.READ
//
//  Created by 심근웅 on 6/9/25.
//

import Foundation
import SwiftUI

/// 텍스트필드 외의 다른 부분 터치 시 키보드 내림
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
}
