//
//  BookViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import Foundation
import SwiftUI

final class BookViewModel: ObservableObject {
  var isbn: String
  
  @Published var text: String = "BookDetailView입니다. 아직 아무것도 없습니다."
  @Published var bookVO: BookDetailVO
  @Published var selectedState: ReadingState = .notStart

  init(isbn: String) {
    self.isbn = isbn
    
    self.bookVO = BookDetailVO(
      title: "데미안 (오리지널 초판본 표지디자인) - 최신 원전 완역본",
      author: "헤르만 헤세 (지은이), 이미영 (옮긴이), 김선형 (해설)",
      publishedDate: "2017-01-01",
      description: "헤르만 헤세의 ‘영혼의 전기’로 소개되는 《데미안》은 깊이 있는 정신분석과 자기 탐구로 가시밭 같은 자아 성찰의 길을 섬세하게 그려낸 그의 대표작이다. 이 책을 1919년 오리지널 초판본의 우아한 표지로 다시 만나보자.",
      isbn: "9791187011590",
      coverURL: "https://image.aladin.co.kr/product/9871/8/coversum/k042535550_2.jpg",
      publisher: "코너스톤",
      pageCount: 220,
      ratingScore: 9.6,
      ratingCount: 25,
      link: "https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=98710881&amp;partner=openAPI&amp;start=api"
    )
  }
  
}

struct ImageURLConverter {
  /// 썸네일(coversum)을 고화질(cover500)로 변환
  static func highQualityURL(from originalURL: String) -> String {
    originalURL.replacingOccurrences(of: "/coversum/", with: "/cover500/")
  }
}
