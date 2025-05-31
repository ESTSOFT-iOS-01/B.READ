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
  let content: String
  let page: Int
  
  init(id: String, content: String, page: Int) {
    self.id = id
    self.content = content
    self.page = page
  }
  
  init(_ quote: Quote) {
    self.id = quote.id
    self.content = quote.content
    self.page = quote.page
  }
  
  static func == (lhs: QuoteVO, rhs: QuoteVO) -> Bool {
    if lhs.id != rhs.id { return false }

    return true
  }
  
}

