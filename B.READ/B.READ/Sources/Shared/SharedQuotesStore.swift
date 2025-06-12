//
//  SharedQuotesStore.swift
//  B.READ
//
//  Created by 도민준 on 6/9/25.
//

import Foundation

/// 위젯과 본앱이 함께 쓰는 “문장 + 책제목” 캐시 저장소
enum SharedQuotesStore {

  private static let suiteID = "group.BREAD"
  private static let key     = "savedQuotes"

  private static var defaults: UserDefaults? {
    UserDefaults(suiteName: suiteID)
  }

  // MARK: - Public API
  /// 전체 문장 덤프를 저장 (본앱 → 호출)
  static func save(_ quotes: [SharedQuote]) throws {
    let data = try JSONEncoder().encode(quotes)
    defaults?.set(data, forKey: key)
  }

  /// 저장된 문장 배열을 로드 (위젯 → 호출)
  static func load() -> [SharedQuote] {
    guard
      let data = defaults?.data(forKey: key),
      let quotes = try? JSONDecoder().decode([SharedQuote].self, from: data)
    else { return [] }
    return quotes
  }
}
