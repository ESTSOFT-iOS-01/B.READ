//
//  UserInfo.swift
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
