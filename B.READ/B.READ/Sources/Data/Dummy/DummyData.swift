//
//  DummyData.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import Foundation
import SwiftUI

enum DummyData { }

// MARK: - Book
extension DummyData {
  static let dummyBooks: [Book] = [
    Book(
      isbn: "9791194368137",
      name: "워런 버핏 웨이",
      author: "로버트 해그스트롬",
      publisher: "상상스퀘어",
      publishedAt: Calendar.current.date(from:DateComponents(year: 2025, month: 5, day: 21))!,
      totalPages: 500
    ),
    Book(
      isbn: "9791158510619",
      name: "타이탄의 도구들",
      author: "팀 페리스",
      publisher: "토네이도",
      publishedAt: Calendar.current.date(from:DateComponents(year: 2022, month: 6, day: 22))!,
      totalPages: 367
    ),
    Book(
      isbn: "9788937460586",
      name: "싯다르타",
      author: "헤르만헤세",
      publisher: "민음사",
      publishedAt: Calendar.current.date(from: DateComponents(year: 2002, month: 1, day: 20))!,
      totalPages: 252
    ),
    Book(
      isbn: "9791162540640",
      name: "아주 작은 습관들",
      author: "제임스 클리어",
      publisher: "비즈니스북스",
      publishedAt: Calendar.current.date(from: DateComponents(year: 2019, month: 2, day: 26))!,
      totalPages: 360
    ),
    Book(
      isbn: "9791192372730",
      name: "위버멘쉬",
      author: "프리드리히 니체",
      publisher: "RISE(떠오름)",
      publishedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 14))!,
      totalPages: 260
    ),
    Book(
      isbn: "9788932473901",
      name: "이기적 유전자",
      author: "리처드 도킨스",
      publisher: "을유문화사",
      publishedAt: Calendar.current.date(from: DateComponents(year: 2018, month: 10, day: 20))!,
      totalPages: 632
    ),
    Book(
      isbn: "9791194368175",
      name: "듀얼 브레인",
      author: "이선 몰릭",
      publisher: "상상스퀘어",
      publishedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 19))!,
      totalPages: 308
    )
  ]
}

// MARK: - Record
extension DummyData {
  static var dummyRecords: [Record] = [
    Record( // 워런 버핏 웨이
      id: UUID().uuidString,
      isbn: "9791194368137",
      state: .toRead,
      heartCount: 3,
      starCount: 0,
      isFavorite: false,
      period: (nil, nil),
      currentPage: 0,
      review: "",
      summaryID: nil,
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 17))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 17))!
          ),
    Record( // 타이탄의 도구들
      id: UUID().uuidString,
      isbn: "9791158510619",
      state: .reading,
      heartCount: 0,
      starCount: 0,
      isFavorite: true,
      period: (Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11)), nil),
      currentPage: 123,
      review: "",
      summaryID: nil,
      memoIDs: ["5", "6"],
      quoteIDs: ["4", "5"],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!
          ),
    Record( // 싯다르타
      id: UUID().uuidString,
      isbn: "9788937460586",
      state: .completed,
      heartCount: 0,
      starCount: 4,
      isFavorite: false,
      period: (
        Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20)),
        Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))
      ),
      currentPage: 252,
      review: "",
      summaryID: nil,
      memoIDs: ["1", "2", "3", "4"],
      quoteIDs: ["1", "2", "3"],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))!
          ),
    Record( // 아주 작은 습관들
      id: UUID().uuidString,
      isbn: "9791162540640",
      state: .reading,
      heartCount: 3,
      starCount: 0,
      isFavorite: true,
      period: (Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 27)), nil),
      currentPage: 321,
      review: "",
      summaryID: nil,
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!
          ),
    Record( // 위버멘쉬
      id: UUID().uuidString,
      isbn: "9791192372730",
      state: .completed,
      heartCount: 3,
      starCount: 5,
      isFavorite: false,
      period: (
        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)),
        Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))
      ),
      currentPage: 260,
      review: "",
      summaryID: nil,
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
          ),
    Record( // 이기적 유전자
      id: UUID().uuidString,
      isbn: "9788932473901",
      state: .completed,
      heartCount: 3,
      starCount: 2,
      isFavorite: false,
      period: (
        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)),
        Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))
      ),
      currentPage: 632,
      review: "",
      summaryID: nil,
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 30))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 30))!
          ),
    Record( // 듀얼 브레인
      id: UUID().uuidString,
      isbn: "9791194368175",
      state: .completed,
      heartCount: 3,
      starCount: 4,
      isFavorite: false,
      period: (
        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)),
        Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))
      ),
      currentPage: 308,
      review: "",
      summaryID: nil,
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25))!
          )
  ]
}

// MARK: - Memo
extension DummyData {
  static let dummyMemos: [Memo] = [
    Memo(
      id: "1",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (10, 20),
      guides: ["1제안", "2제안"]
    ),
    Memo(
      id: "2",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (22, 32),
      guides: ["1제안", "2제안"]
    ),
    Memo(
      id: "3",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 27))!,
      content: "이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.",
      pages: (44, 82),
      guides: ["1제안", "2제안"]
    ),
    Memo(
      id: "4",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (100, 132),
      guides: ["1제안", "2제안"]
    ),
    Memo(
      id: "5",
      isbn: "9791158510619",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (99, 111),
      guides: ["1제안", "2제안"]
    ),
    Memo(
      id: "6",
      isbn: "9791158510619",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (12, 25),
      guides: ["1제안", "2제안"]
    )
  ]
}

// MARK: - Quote
extension DummyData {
  static let dummyQuote: [Quote] = [
    Quote(id: "1", isbn: "9788937460586", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 77),
    Quote(id: "2", isbn: "9788937460586", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 12),
    Quote(id: "3", isbn: "9788937460586", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 35),
    Quote(id: "4", isbn: "9791158510619", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 123),
    Quote(id: "5", isbn: "9791158510619", content: "수집된 문장 문장 수집된 문장 수집된 문장 수집된 문장", page: 72),
  ]
}

// MARK: - AI Note
extension DummyData {
  
}
