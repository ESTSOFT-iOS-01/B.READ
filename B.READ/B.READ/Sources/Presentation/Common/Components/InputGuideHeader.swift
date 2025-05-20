//
//  InputGuideHeader.swift
//  B.READ
//
//  Created by 신승재 on 5/18/25.
//

import SwiftUI

enum GuideType {
  case nickname
  case category
  
  var title: String {
    switch self {
    case .nickname:
      "사용할 닉네임을 입력해주세요."
    case .category:
      "관심 분야를 선택해 주세요."
    }
  }
  
  var subTitle: String {
    switch self {
    case .nickname:
      "영어, 한글, 숫자로 최대 12자까지 설정할 수 있습니다."
    case .category:
      "선택한 분야에 맞는 도서를 추천해 드려요 (2개 선택)"
    }
  }
}

struct InputGuideHeader: View {
  
  let type: GuideType
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(type.title)
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 24), lineHeight: 1.4)
      
      Text(type.subTitle)
        .foregroundStyle(.gray5)
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.35)
    }.padding(.leading, 6)
  }
}
