//
//  RecordMemoVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

struct RecordMemoVO: Identifiable {
  let id: String
  let isbn: String
  let createdAt: Date
  let content: String
  let pages: (Int, Int)
  let guides: [String]
  
  init(
    id: String,
    isbn: String,
    createdAt: Date,
    content: String,
    pages: (Int, Int),
    guides: [String]
  ) {
    self.id = id
    self.isbn = isbn
    self.createdAt = createdAt
    self.content = content
    self.pages = pages
    self.guides = guides
  }
  
  init(_ memo: Memo) {
    self.init(
      id: memo.id,
      isbn: memo.isbn,
      createdAt: memo.createdAt,
      content: memo.content,
      pages: memo.pages,
      guides: memo.guides
    )
  }
}
