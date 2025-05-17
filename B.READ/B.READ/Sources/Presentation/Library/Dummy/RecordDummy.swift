//
//  RecordDummy.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

// MARK: - Record, ReadState Entity
// TODO: - Entity 머지 되면 해당 Entity 삭제
/// 독서 기록(책빵)입니다.
/// - id : 독서기록의 uuid
/// - isbn : 도서의 ISBN 정보
/// - state : 독서 상태
/// - heartCount : 기대 지수
/// - starCount : 평점
/// - isFavorite : 즐겨찾기 상태
/// - period : (읽기 시작 날짜, 읽기 종료 날짜)
/// - currentPage : 현재까지 읽은 페이지
/// - review : 한줄평(150자 이내)
/// - summaryID : AI 요약노트 id (빵식이의 요약노트)
/// - memoIDs : 메모 id - [String]
/// - quoteIDs : 문장수집 id - [String]
/// - createdAt : 독서기록 생성 날짜
struct Record {
  let id: String
  let isbn: String
  var state: ReadState
  var heartCount: Int
  var starCount: Int
  var isFavorite: Bool
  var period: (Date?, Date?)
  var currentPage: Int
  var review: String
  var summaryID: String?
  var memoIDs: [String]
  var quoteIDs: [String]
  let createdAt: Date
}

/// 독서 상태 정보입니다.
/// - toRead : 읽을 책
/// - reading : 읽는 중
/// - completed : 읽은 책
enum ReadState: Int {
  case toRead = 0
  case reading
  case completed
}




// MARK: - Record Dummy Datas
let dummyRecords: [Record] = [
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
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 17))!
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
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 11))!
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
    memoIDs: [],
    quoteIDs: [],
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!
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
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!
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
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1))!
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
    createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 30))!
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
    createdAt: Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 25))!
  )
]
