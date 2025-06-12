//
//  SummaryDTO.swift
//  B.READ
//
//  Created by 심근웅 on 6/2/25.
//

import Foundation
import SwiftData

@Model
final class SummaryDTO {
  @Attribute(.unique)
  var id: String
  var isbn: String
  var content: String
  var createdAt: Date
  
  var record: RecordDTO
  
  init(id: String, isbn: String, content: String, createdAt: Date, record: RecordDTO) {
    self.id = id
    self.isbn = isbn
    self.content = content
    self.createdAt = createdAt
    self.record = record
  }
  
  init(_ data: AlanSummary, record: RecordDTO) {
    self.id = data.id
    self.isbn = data.isbn
    self.content = data.content
    self.createdAt = data.createdAt
    self.record = record
  }
}

extension SummaryDTO {
  func toEntity() -> AlanSummary {
    return AlanSummary(
      id: self.id,
      isbn: self.isbn,
      content: self.content,
      createdAt: self.createdAt
    )
  }
}
