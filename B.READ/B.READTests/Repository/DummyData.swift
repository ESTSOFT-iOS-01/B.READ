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
