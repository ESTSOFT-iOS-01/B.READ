//
//  Quote.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

/// 독서 문장 수집입니다.
/// - id : 문장 수집의 uuid
/// - isbn : 문장 수집이 작성될 책의 ISBN
/// - content : 내용
/// - page : 문장 수집 페이지
struct Quote: Identifiable, Equatable, Hashable {
  let id: String
  let isbn: String
  var content: String
  var page: Int
}
