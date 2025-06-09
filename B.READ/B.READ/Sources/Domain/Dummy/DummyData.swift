//
//  DummyData.swift
//  B.READ
//
//  Created by 심근웅 on 5/18/25.
//

import Foundation
import SwiftUI

public enum DummyData { }

// MARK: - UserInfo
extension DummyData {
  static var userInfo = UserInfo(
    nickname: "모옹피",
    categories: [
      Category(id: 101, name: "소설"),
      Category(id: 203, name: "에세이")
    ],
    recentKeywords: [
      Keyword(date: Date().addingTimeInterval(-86400 * 2), value: "히가시노 게이고"),
      Keyword(date: Date().addingTimeInterval(-86400 * 1), value: "미움받을 용기")
    ],
    generateCount: 3,
    lastStreakUpdatedAt: Date(),
    streak: (0...6).map { index in
      DailyStatus(weekday: index, isCompleted: index % 2 == 0)
    }
  )
}

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
  static func createDummyRecords() -> [Record] {
    return dummyRecords
  }
  
  static var dummyRecords: [Record] = [
  Record( // 워런 버핏 웨이
    id: "1",
    isbn: "9791194368137",
    state: .toRead,
    heartCount: 3,
    starCount: 0,
    isFavorite: false,
    period: (nil, nil),
    currentPage: 0,
    review: "",
    summary: nil,
    memos: [],
    quotes: [],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 17))!,
    updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 17))!
        ),
  Record( // 타이탄의 도구들
    id: "2",
    isbn: "9791158510619",
    state: .reading,
    heartCount: 0,
    starCount: 0,
    isFavorite: true,
    period: (Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11)), nil),
    currentPage: 123,
    review: "",
    memos: [],
    quotes: [],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
    updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!
        ),
  Record( // 싯다르타
    id: "3",
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
    memos: [
      Memo(
        id: "1",
        isbn: "9788937460586",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
        content: "싯다르타는 수많은 스승과 가르침을 거쳤지만, 결국 삶을 살아가는 과정에서 스스로 진리를 깨닫는다. 남의 말이 아닌, 체험이 지혜로 이어진다.",
        pages: (100, 132),
        guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
      ),
      Memo(
        id: "2",
        isbn: "9788937460586",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
        content: "강을 바라보며 싯다르타는 모든 존재가 연결되어 흐르고 있다는 사실을 깨닫는다. 나 또한 변화와 흐름을 있는 그대로 받아들이고 싶어졌다.",
        pages: (100, 132),
        guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
      ),
      Memo(
        id: "3",
        isbn: "9788937460586",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
        content: "싯다르타의 삶은 고통과 실수의 연속이었지만, 그 모든 것이 깨달음으로 나아가는 길이었다. 나 역시 내 방황을 긍정하고 싶어졌다.",
        pages: (100, 132),
        guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
      ),
    ],
    quotes: [],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
    updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))!
  )
  
  
//    Record( // 아주 작은 습관들
//      id: UUID().uuidString,
//      isbn: "9791162540640",
//      state: .reading,
//      heartCount: 3,
//      starCount: 0,
//      isFavorite: true,
//      period: (Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 27)), nil),
//      currentPage: 321,
//      review: "",
//      summaryID: nil,
//      memoIDs: [],
//      quoteIDs: [],
//      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!,
//      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!
//          ),
//    Record( // 위버멘쉬
//      id: UUID().uuidString,
//      isbn: "9791192372730",
//      state: .completed,
//      heartCount: 3,
//      starCount: 5,
//      isFavorite: false,
//      period: (
//        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)),
//        Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))
//      ),
//      currentPage: 260,
//      review: "",
//      summaryID: nil,
//      memoIDs: [],
//      quoteIDs: [],
//      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!,
//      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
//          ),
//    Record( // 이기적 유전자
//      id: UUID().uuidString,
//      isbn: "9788932473901",
//      state: .completed,
//      heartCount: 3,
//      starCount: 2,
//      isFavorite: false,
//      period: (
//        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)),
//        Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))
//      ),
//      currentPage: 632,
//      review: "",
//      summaryID: nil,
//      memoIDs: [],
//      quoteIDs: [],
//      createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 30))!,
//      updatedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 30))!
//          ),
//    Record( // 듀얼 브레인
//      id: UUID().uuidString,
//      isbn: "9791194368175",
//      state: .completed,
//      heartCount: 3,
//      starCount: 4,
//      isFavorite: false,
//      period: (
//        Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)),
//        Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))
//      ),
//      currentPage: 308,
//      review: "",
//      summaryID: nil,
//      memoIDs: [],
//      quoteIDs: [],
//      createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25))!,
//      updatedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25))!
//          )
]
  
  static var records: [Record] = [
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
      summary: nil,
      memos: [],
      quotes: [],
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
      memos: [],
      quotes: [],
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
      memos: [],
      quotes: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))!
    )
  ]
}

// MARK: - Memo
extension DummyData {
  static let fixedDate: Date = .now
  static let dummyMemos: [Memo] = [
    Memo(
      id: "1",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (10, 20),
      guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
    ),
    Memo(
      id: "2",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (22, 32),
      guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
    ),
    Memo(
      id: "3",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 27))!,
      content: "이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.이것은 테스트를 위한 메모입니다.",
      pages: (44, 82),
      guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
    ),
    Memo(
      id: "4",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (100, 132),
      guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
    ),
    Memo(
      id: "5",
      isbn: "9788937460586",
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
      content: "이것은 테스트를 위한 메모입니다.",
      pages: (99, 111),
      guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
    )
  ]
}

// MARK: - Quote
extension DummyData {
  static let quote = Quote(id: "1", isbn: "9791158510619", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 77)
  
  static let dummyQuote: [Quote] = [
    Quote(id: "1", isbn: "9791158510619", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 77),
    Quote(id: "2", isbn: "9791158510619", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 12),
    Quote(id: "3", isbn: "9791158510619", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 35),
    Quote(id: "4", isbn: "9788937460586", content: "수집된 문장 수집된 문장 수집된 문장 수집된 문장", page: 123),
    Quote(id: "5", isbn: "9788937460586", content: "수집된 문장 문장 수집된 문장 수집된 문장 수집된 문장", page: 72),
  ]
}

// MARK: - AI Note
extension DummyData {
  static let bookForSummary = Book(
    isbn: "9788937460586",
    name: "싯다르타",
    author: "헤르만헤세",
    publisher: "민음사",
    publishedAt: Calendar.current.date(from: DateComponents(year: 2002, month: 1, day: 20))!,
    totalPages: 252
  )
  
  static let recordForSummary = Record( // 싯다르타
    id: "3",
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
    memos: [
      Memo(
        id: "1",
        isbn: "9788937460586",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
        content: "싯다르타는 수많은 스승과 가르침을 거쳤지만, 결국 삶을 살아가는 과정에서 스스로 진리를 깨닫는다. 남의 말이 아닌, 체험이 지혜로 이어진다.",
        pages: (100, 132),
        guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
      ),
      Memo(
        id: "2",
        isbn: "9788937460586",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
        content: "강을 바라보며 싯다르타는 모든 존재가 연결되어 흐르고 있다는 사실을 깨닫는다. 나 또한 변화와 흐름을 있는 그대로 받아들이고 싶어졌다.",
        pages: (100, 132),
        guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
      ),
      Memo(
        id: "3",
        isbn: "9788937460586",
        createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 4))!,
        content: "싯다르타의 삶은 고통과 실수의 연속이었지만, 그 모든 것이 깨달음으로 나아가는 길이었다. 나 역시 내 방황을 긍정하고 싶어졌다.",
        pages: (100, 132),
        guides: [Guide(date: fixedDate, content: "exmaple1"), Guide(date: fixedDate, content: "exmaple1")]
      ),
    ],
    quotes: [],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
    updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))!
  )
  
  static let summary1 = AlanSummary(
    id: "summary-1",
    isbn: "9791194368137",
    content: "워런 버핏의 투자 철학 요약입니다.",
    tags: [Tag(id: "t1", content: "투자"), Tag(id: "t2", content: "버핏")],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 18))!
  )
  
  static let summary2 = AlanSummary(
    id: "summary-2",
    isbn: "9791158510619",
    content: "타이탄의 도구들 핵심 내용을 정리했습니다.",
    tags: [Tag(id: "t3", content: "자기계발"), Tag(id: "t4", content: "성공")],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 12))!
  )
  
  static let summary3 = AlanSummary(
    id: "summary-3",
    isbn: "9788937460586",
    content: "싯다르타의 삶과 깨달음 요약본.",
    tags: [Tag(id: "t5", content: "철학"), Tag(id: "t6", content: "삶")],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!
  )
  
  static var dummySummaries: [AlanSummary] {
    [summary1, summary2, summary3]
  }
}

