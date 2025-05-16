//
//  Record.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

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
/// - memoIDs : 메모 id
/// - quoteIDs : 문장수집 id
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
}

/// 독서 상태 정보입니다.
/// - toRead : 읽을 책
/// - reading : 읽는 중
/// - complete : 읽은 책
enum ReadState: Int {
  case toRead = 0
  case reading
  case completed
}
