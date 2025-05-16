//
//  Entity.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

/// 기본 유저 정보입니다.
/// - nickname : 유저 닉네임(영어, 한글, 숫자, 12자 이내)
/// - category : 선호장르
/// - recentKeywords : 최근 검색어
/// - generateCount : ai 요약 생성횟수
/// - streak : 일주일간의 독서 유무
struct UserInfo {
  var nickname: String
  var category: [Category]
  var recentKeywords: [String]
  var generateCount: Int
  var streak: [Bool]
}

/// 책 장르 입니다.
/// 선호 도서 추천에서 사용됩니다.
/// - id : 알라딘 API의 장르 CID
/// - name : 장르명
struct Category {
  let id: Int
  let name: String
}


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

/// AI 요약노트입니다.
/// (빵식이의 요약노트)
/// - id : 요약노트의 uuid
/// - isbn : 요약노트에 사용된 도서의 ISBN
/// - content : 요약노트 내용(마크다운)
/// - createdAt : 생성날짜
struct AlanSummary {
  let id: String
  let isbn: String
  let content: String
  let createdAt: Date
}


/// 도서 정보입니다.
/// - isbn : ISBN
/// - coverImg : 표지
/// - name : 제목
/// - author : 작가 // TODO : 번역가, 옮김이 포함되는지 확인 필요
/// - publisher : 출판사
/// - publishedAt : 출판일
/// - totalPages: 총 페이지
struct Book {
  let isbn: String
  var coverImg: Data?
  let name: String
  let author: String
  let publisher: String
  let publishedAt: Date
  let totalPages: Int
}

/// 독서 메모입니다.
/// - id : 메모의 uuid
/// - isbn : 메모가 작성될 책의 ISBN
/// - createdAt : 생성 날짜
/// - content : 내용
/// - pages : (메모 첫 페이지, 메모 끝 페이지)
/// - guide : AI 제안 내용
struct Memo {
  let id: String
  let isbn: String
  var createdAt: Date
  var content: String
  var pages: (Int, Int)
  var guide: [String]
}

/// 독서 문장 수집입니다.
/// - id : 문장 수집의 uuid
/// - isbn : 문장 수집이 작성될 책의 ISBN
/// - content : 내용
/// - page : 문장 수집 페이지
struct Quote {
  let id: String
  let isbn: String
  var content: String
  var page: Int
}
