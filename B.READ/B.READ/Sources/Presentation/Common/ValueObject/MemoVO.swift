//
//  MemoVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

// MARK: - (S)MemoGroup
struct MemoGroup: Identifiable {
  let id = UUID()
  let isbn: String
  let bookTitle: String
  var memos: [MemoVO]
}

// MARK: - (S)MemoVO
struct MemoVO: Identifiable {
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
      guides: memo.guides.map { $0.content }
    )
  }
}

extension MemoVO {
  // TODO: - Guide에는 date도 있음
  func toEntity() -> Memo {
    Memo(
      id: self.id,
      isbn: self.isbn,
      createdAt: self.createdAt,
      content: self.content,
      pages: self.pages,
      guides: self.guides.map { Guide(date: Date(), content: $0) }
    )
  }
}
