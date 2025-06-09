//
//  SortOption.swift
//  B.READ
//
//  Created by 심근웅 on 6/2/25.
//

import Foundation

// 정렬을 부르는 탭의 종류
enum SortTabType {
  case library
  case quote
  case memo
  case note
}

// 정렬 기준
enum SortOption: String, CaseIterable, Identifiable {
  
  case recent = "최신 순"
  case oldest = "오래된 순"
  case pageAscending = "오름차 순"
  case pageDescending = "내림차 순"
  
  // ForEach를 위한 id 추가
  var id: String { self.rawValue }
  
  // 화면에 따른 Option 반환
  static func sortMenus(type: SortTabType) -> [SortOption] {
    switch type {
    case .library: [.recent, .oldest]
    case .quote, .memo: [.pageAscending, .pageDescending]
    case .note: [.recent, .oldest]
    }
  }
}

extension SortOption {
  
  // RecordCellVO를 쓸때의 정렬
  func sort(_ lhs: RecordCellVO, _ rhs: RecordCellVO) -> Bool {
    switch self {
    case .recent: lhs.createdAt > rhs.createdAt
    case .oldest: lhs.createdAt < rhs.createdAt
    default: true
    }
  }
  
  // MemoGroup을 쓸때 정렬
  func sort(_ lhs: MemoGroup, _ rhs: MemoGroup) -> Bool {
    return lhs.bookTitle < rhs.bookTitle
  }
  
  // MemoVO를 쓸때 정렬
  func sort(_ lhs: MemoVO, _ rhs: MemoVO) -> Bool {
    switch self {
    case .pageAscending:
      lhs.pages.0 == rhs.pages.0
      ? lhs.pages.1 < rhs.pages.1
      : lhs.pages.0 < rhs.pages.0
      
    case .pageDescending:
      lhs.pages.0 == rhs.pages.0
      ? lhs.pages.1 > rhs.pages.1
      : lhs.pages.0 > rhs.pages.0
      
    default: true
    }
  }
  
  // QuoteGroup을 쓸때 정렬
  func sort(_ lhs: QuoteGroup, _ rhs: QuoteGroup) -> Bool {
    return lhs.bookTitle < rhs.bookTitle
  }
  
  // QuoteVO를 쓸때 정렬
  func sort(_ lhs: QuoteVO, _ rhs: QuoteVO) -> Bool {
    switch self {
    case .pageAscending: lhs.page < rhs.page
    case .pageDescending: lhs.page > rhs.page
    default: true
    }
  }
  
  // AI Summary를 쓸때 정렬
  func sort(_ lhs: NoteVO, _ rhs: NoteVO) -> Bool {
    switch self {
    case .recent: lhs.createdAt > rhs.createdAt
    case .oldest: lhs.createdAt < rhs.createdAt
    default: true
    }
  }
}
