//
//  Memo.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

/// 독서 메모입니다.
/// - id : 메모의 uuid
/// - isbn : 메모가 작성될 책의 ISBN
/// - createdAt : 생성 날짜
/// - content : 내용
/// - pages : (메모 첫 페이지, 메모 끝 페이지)
/// - guides : AI 제안 내용 - [String]
struct Memo: Identifiable {
  let id: String
  let isbn: String
  var createdAt: Date
  var content: String
  var pages: (Int, Int)
  var guides: [Guide]
  
  init(
    id: String,
    isbn: String,
    createdAt: Date,
    content: String,
    pages: (Int, Int),
    guides: [Guide]
  ) {
    self.id = id
    self.isbn = isbn
    self.createdAt = createdAt
    self.content = content
    self.pages = pages
    self.guides = guides
  }
}

struct Guide {
  let date: Date
  var content: String
  
  init(date: Date, content: String) {
    self.date = date
    self.content = content
  }
}
