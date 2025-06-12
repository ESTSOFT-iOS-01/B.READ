//
//  Date+.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import Foundation

extension Date {
  enum DateFormatType: String {
    case dotSeparated = "yyyy. MM. dd"
    case dotSeparatedFull = "yyyy. MM. dd. (E)"
  }
  
  static private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }()
  
  /// Date를 String Format으로 변환합니다
  /// - Parameter dateFormatType: 변환하고 싶은 dateFormat 타입
  /// - Returns: 변환된 String 값
  func string(format dateFormatType: DateFormatType) -> String {
    Self.dateFormatter.dateFormat = dateFormatType.rawValue
    return Self.dateFormatter.string(from: self)
  }
}
