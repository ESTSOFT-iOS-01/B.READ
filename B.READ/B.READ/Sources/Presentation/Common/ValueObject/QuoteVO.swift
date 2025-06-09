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

extension QuoteGroup: Equatable {
  static func == (lhs: QuoteGroup, rhs: QuoteGroup) -> Bool {
    return lhs.id == rhs.id &&
    lhs.isbn == rhs.isbn &&
    lhs.bookTitle == rhs.bookTitle &&
    lhs.quotes == rhs.quotes
  }
}

// MARK: - (S)QuoteVO
struct QuoteVO: Identifiable, Hashable {
  let id: String
  let isbn: String
  let content: String
  let page: Int
  let record: RecordDetailVO
  
  init(id: String, isbn: String, content: String, page: Int, record: RecordDetailVO) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.page = page
    self.record = record
  }
  
  init(_ quote: Quote, record: RecordDetailVO) {
    self.id = quote.id
    self.isbn = quote.isbn
    self.content = quote.content
    self.page = quote.page
    self.record = record
  }
  
  static func == (lhs: QuoteVO, rhs: QuoteVO) -> Bool {
    return lhs.id != rhs.id &&
    lhs.content != rhs.content &&
    lhs.page != rhs.page &&
    lhs.isbn != rhs.isbn
  }
}

extension QuoteVO {
  func toEntity() -> Quote {
    Quote(id: self.id, isbn: self.isbn, content: self.content, page: self.page)
  }
}
