//
//  String+.swift
//  B.READ
//
//  Created by 김도연 on 5/27/25.
//

import Foundation

extension String {
  func toDotDateFormat() -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy. MM. dd."

    if let date = inputFormatter.date(from: self) {
      return outputFormatter.string(from: date)
    } else {
      return self // 파싱 실패 시 원본 반환
    }
  }
}
