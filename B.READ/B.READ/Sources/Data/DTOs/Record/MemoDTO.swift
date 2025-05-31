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
  
  @Relationship(deleteRule: .cascade)
  var guides: [GuideDTO]
  
  init(
    id: String,
    isbn: String,
    createdAt: Date,
    content: String,
    startPage: Int,
    endPage: Int,
    guides: [GuideDTO]
  ) {
    self.id = id
    self.isbn = isbn
    self.createdAt = createdAt
    self.content = content
    self.startPage = startPage
    self.endPage = endPage
    self.guides = guides
  }
  
  convenience init(_ data: Memo) {
    self.init(
      id: data.id,
      isbn: data.isbn,
      createdAt: data.createdAt,
      content: data.content,
      startPage: data.pages.0,
      endPage: data.pages.1,
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
