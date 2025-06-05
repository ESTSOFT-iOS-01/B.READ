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
  
  init(
    nickname: String,
    categories: [Category],
    recentKeywords: [Keyword],
    generateCount: Int,
    lastStreakUpdatedAt: Date,
    streak: [DailyStatus]
  ) {
    self.nickname = nickname
    self.categories = categories
    self.recentKeywords = recentKeywords
    self.generateCount = generateCount
    self.lastStreakUpdatedAt = lastStreakUpdatedAt
    self.streak = streak
  }
}

/// 최근 검색 키워드입니다.
/// - date: 키워드를 검색한 날짜
/// - value: 검색한 키워드 문자열
struct Keyword: Equatable {
  let date: Date
  let value: String
  
  init(date: Date, value: String) {
    self.date = date
    self.value = value
  }
}


/// 요일별 독서 스트릭의 하루별 상태입니다..
/// - weekday: 요일 인덱스 (0 = 일요일 ~ 6 = 토요일)
/// - isCompleted: 해당 요일에 독서를 메모, 문장작성을 완료 했는지 여부
struct DailyStatus: Equatable {
  let weekday: Int
  var isCompleted: Bool
  
  init(weekday: Int, isCompleted: Bool) {
    self.weekday = weekday
    self.isCompleted = isCompleted
  }
}

/// 책 장르입니다.
/// 선호 도서 추천에서 사용됩니다.
/// - id : 알라딘 API의 장르 CID
/// - name : 장르명
struct Category: Equatable {
  let id: Int
  let name: String
  
  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

enum CategoryType: Int, CaseIterable {
  case homeCookingBeauty = 1230
  case healthHobbyLeisure = 55890
  case economics = 170
  case classics = 2105
  case science = 987
  case comics = 2551
  case socialScience = 798
  case literature = 1
  case essay = 55889
  case travel = 1196
  case history = 74
  case artCulture = 517
  case foreignLanguage = 1322
  case humanities = 656
  case selfDevelopment = 336
  case magazine = 2913
  case genreFiction = 112011
  case religionPhilosophy = 1237
  case computerMobile = 351

  var name: String {
    switch self {
    case .homeCookingBeauty: "가정/요리/뷰티"
    case .healthHobbyLeisure: "건강/취미/레저"
    case .economics: "경제경영"
    case .classics: "고전"
    case .science: "과학"
    case .comics: "만화"
    case .socialScience: "사회과학"
    case .literature: "소설/시/희곡"
    case .essay: "에세이"
    case .travel: "여행"
    case .history: "역사"
    case .artCulture: "예술/대중문화"
    case .foreignLanguage: "외국어"
    case .humanities: "인문학"
    case .selfDevelopment: "자기계발"
    case .magazine: "잡지"
    case .genreFiction: "장르소설"
    case .religionPhilosophy: "종교/역학"
    case .computerMobile: "컴퓨터/모바일"
    }
  }
  
  var cid: Int {
    self.rawValue
  }
}
