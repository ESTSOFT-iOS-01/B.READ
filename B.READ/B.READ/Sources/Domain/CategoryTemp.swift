//
//  Category.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import Foundation

enum CategoryTemp: Int, CaseIterable {
  case homeCookingBeauty = 0
  case healthHobbyLeisure
  case economics
  case classics
  case science
  case comics
  case socialScience
  case literature
  case essay
  case travel
  case history
  case artCulture
  case foreignLanguage
  case humanities
  case selfDevelopment
  case magazine
  case genreFiction
  case religionPhilosophy
  case computerMobile

  var displayName: String {
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
}
