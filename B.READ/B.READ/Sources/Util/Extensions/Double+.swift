//
//  Double+.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import Foundation

extension Double {
  /// 소숫점 첫째짜리까지 표현되는 문자열로 변환합니다.
  var toStringForOneDecimal: String {
    String(format: "%.1f", self)
  }
}
