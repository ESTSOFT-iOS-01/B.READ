//
//  MemoDTO.swift
//  B.READ
//
//  Created by 신승재 on 5/29/25.
//

import Foundation
import SwiftData

@Model
final class MemoDTO {
  @Attribute(.unique)
  var id: String
  var isbn: String
  var createdAt: Date
  var content: String
  var startPage: Int
  var endPage: Int
  var guides: [GuideDTO]
  
  init(
    id: String,
    isbn: String,
    createdAt: Date,
    content: String,
    pages: (Int, Int),
    guides: [GuideDTO]
  ) {
    self.id = id
    self.isbn = isbn
    self.createdAt = createdAt
    self.content = content
    self.startPage = pages.0
    self.endPage = pages.0
    self.guides = guides
  }
  
  convenience init(_ data: Memo) {
    self.init(
      id: data.id,
      isbn: data.isbn,
      createdAt: data.createdAt,
      content: data.content,
      pages: data.pages,
      guides: data.guides.map { GuideDTO($0) }
    )
  }
}

extension MemoDTO {
  func toEntity() -> Memo {
    return Memo(
      id: self.id,
      isbn: self.isbn,
      createdAt: self.createdAt,
      content: self.content,
      pages: (self.startPage, self.endPage),
      guides: self.guides.map { $0.toEntity() }
    )
  }
}
