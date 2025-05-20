//
//  QuoteDTO.swift
//  B.READ
//
//  Created by 도민준 on 5/20/25.
//

import Foundation
import SwiftData

@Model
final class QuoteDTO {
  var id: String
  var isbn: String
  var content: String
  var page: Int

  init(
    id: String = UUID().uuidString,
    isbn: String,
    content: String,
    page: Int
  ) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.page = page
  }

  convenience init(_ entity: Quote) {
    self.init(
      id: entity.id,
      isbn: entity.isbn,
      content: entity.content,
      page: entity.page
    )
  }
}

extension QuoteDTO {
  func toEntity() -> Quote {
    return Quote(
      id: self.id,
      isbn: self.isbn,
      content: self.content,
      page: self.page
    )
  }
