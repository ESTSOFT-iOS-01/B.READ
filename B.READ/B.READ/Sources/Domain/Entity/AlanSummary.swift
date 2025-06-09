//
//  AlanSummary.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

/// AI 요약노트입니다.
/// (빵식이의 요약노트)
/// - id : 요약노트의 uuid
/// - isbn : 요약노트에 사용된 도서의 ISBN
/// - content : 요약노트 내용(마크다운)
/// - createdAt : 생성날짜
struct AlanSummary {
  public let id: String
  let isbn: String
  let content: String
  let tags: [Tag]
  let createdAt: Date
  
  init(id: String, isbn: String, content: String, tags: [Tag], createdAt: Date) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.tags = tags
    self.createdAt = createdAt
  }
}

struct Tag {
  public let id: String
  let content: String
  
  init(id: String, content: String) {
    self.id = id
    self.content = content
  }
}
