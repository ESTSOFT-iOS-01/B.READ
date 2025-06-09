//
//  TagDTO.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation
import SwiftData

@Model
final class TagDTO {
  @Attribute(.unique)
  var id: String
  var content: String
  
  @Relationship var summary: SummaryDTO?
  
  init(id: String, content: String, summary: SummaryDTO? = nil) {
    self.id = id
    self.content = content
    self.summary = summary
  }
  
  convenience init(_ data: Tag, summary: SummaryDTO? = nil) {
    self.init(
      id: data.id,
      content: data.content,
      summary: summary
    )
  }
}

extension TagDTO {
  func toEntity() -> Tag {
    return Tag(
      id: self.id,
      content: self.content
    )
  }
}
