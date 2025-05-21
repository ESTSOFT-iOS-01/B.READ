//
//  DummyData.swift
//  B.READTests
//
//  Created by 신승재 on 5/17/25.
//

import Foundation

enum DummyData {
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

  static var quote = Quote(
    id: "id-1",
    isbn: "123",
    content: "테스트",
    page: 8
  )

  // MARK: - Books Dummy sData
  static var books: [Book] = [
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
    )
  ]
  
  // MARK: - Record Dummy Datas
  static let records: [Record] = [
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
      currentPage: 81,
      review: "",
      summaryID: nil,
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!
    ),
    Record( // 싯다르타
      id: UUID().uuidString,
      isbn: "9788937460586",
      state: .reading,
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
      memoIDs: [],
      quoteIDs: [],
      createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!,
      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!
    )
  ]

}
