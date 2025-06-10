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
  
  /// 문자열을 Date로 변환합니다.
  /// - Parameter format: 기대하는 날짜 포맷 (기본값: "yyyy-MM-dd")
  /// - Returns: 변환된 Date 객체 (nil 반환 가능)
  func toDate(format: String = "yyyy-MM-dd") -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = format
    return formatter.date(from: self)
  }
  
  /// 문자열을 Int로 변환합니다.
  /// - Returns: 변환된 Int 값 (nil 반환 가능)
  func toInt() -> Int? {
    return Int(self)
  }
}
