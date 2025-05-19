//
//  UserInfo.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

/// 기본 유저 정보입니다.
/// - nickname : 유저 닉네임(영어, 한글, 숫자, 12자 이내)
/// - categories : 선호장르 - [Category]
/// - recentKeywords : 최근 검색어 - [Keyword]
/// - generateCount : ai 요약 생성횟수
/// - lastStreakUpdatedAt: 스트릭 업데이트 날짜
/// - streak : 일주일간의 독서 유무 - [DailyStatus]
struct UserInfo: Equatable {
  var nickname: String
  var categories: [Category]
  var recentKeywords: [Keyword]
  var generateCount: Int
  var lastStreakUpdatedAt: Date
  var streak: [DailyStatus]
}

/// 책 장르입니다.
/// 선호 도서 추천에서 사용됩니다.
/// - id : 알라딘 API의 장르 CID
/// - name : 장르명
struct Category: Equatable {
  let id: Int
  let name: String
}

/// 최근 검색 키워드입니다.
/// - date: 키워드를 검색한 날짜
/// - value: 검색한 키워드 문자열
struct Keyword: Equatable {
  let date: Date
  let value: String
}


/// 요일별 독서 스트릭의 하루별 상태입니다..
/// - weekday: 요일 인덱스 (0 = 일요일 ~ 6 = 토요일)
/// - isCompleted: 해당 요일에 독서를 메모, 문장작성을 완료 했는지 여부
struct DailyStatus: Equatable {
  let weekday: Int
  var isCompleted: Bool
}
