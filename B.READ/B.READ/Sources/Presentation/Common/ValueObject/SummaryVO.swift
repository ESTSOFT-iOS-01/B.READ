//
//  SummaryVO.swift
//  B.READ
//
//  Created by 김도연 on 6/10/25.
//

import Foundation

// MARK: - (S)SummaryVO
struct SummaryVO: Identifiable {
  let id: String
  let isbn: String
  let content: String
  let tags: [TagVO]
  let createdAt: Date
  
  init(id: String, isbn: String, content: String, tags: [TagVO], createdAt: Date) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.tags = tags
    self.createdAt = createdAt
  }
  
  init(_ summary: AlanSummary) {
    self.init(
      id: summary.id,
      isbn: summary.isbn,
      content: summary.content,
      tags: summary.tags.map{ TagVO($0) },
      createdAt: summary.createdAt
    )
  }
}

// MARK: - (S)TagVO
struct TagVO: Identifiable, Hashable {
  let id: String
  let content: String
  
  init(id: String, content: String) {
    self.id = id
    self.content = content
  }
  
  init(_ tag: Tag) {
    self.init(
      id: tag.id,
      content: tag.content
    )
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: TagVO, rhs: TagVO) -> Bool {
    return lhs.id == rhs.id &&
    lhs.content == rhs.content
  }
}
