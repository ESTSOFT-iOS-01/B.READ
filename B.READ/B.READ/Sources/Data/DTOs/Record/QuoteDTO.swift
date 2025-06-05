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
  @Attribute(.unique)
  var id: String
  var isbn: String
  var content: String
  var page: Int
  
  var record: RecordDTO?
  
  init(id: String, isbn: String, content: String, page: Int, record: RecordDTO) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.page = page
    self.record = record
  }
  
  convenience init(_ entity: Quote, record: RecordDTO) {
    self.init(
      id: entity.id,
      isbn: entity.isbn,
      content: entity.content,
      page: entity.page,
      record: record
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
}
