//
//  QuoteVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import Foundation

// MARK: - (S)QuoteGroup
struct QuoteGroup: Identifiable {
  let id = UUID()
  let isbn: String
  let bookTitle: String
  var quotes: [QuoteVO]
}

// MARK: - (S)QuoteVO
struct QuoteVO: Identifiable, Hashable {
  let id: String
  let isbn: String
  let content: String
  let page: Int
  
  init(id: String, isbn: String, content: String, page: Int) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.page = page
  }
  
  init(_ quote: Quote) {
    self.id = quote.id
    self.isbn = quote.isbn
    self.content = quote.content
    self.page = quote.page
  }
  
  static func == (lhs: QuoteVO, rhs: QuoteVO) -> Bool {
    if lhs.id != rhs.id { return false }
    if lhs.content != rhs.content { return false }
    if lhs.page != rhs.page { return false }
    if lhs.isbn != rhs.isbn { return false }
    return true
  }
}

extension QuoteVO {
  func toEntity() -> Quote {
    Quote(id: self.id, isbn: self.isbn, content: self.content, page: self.page)
  }
}
