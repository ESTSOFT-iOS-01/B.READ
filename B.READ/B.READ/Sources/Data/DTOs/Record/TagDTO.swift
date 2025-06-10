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
  
  init(id: String, content: String) {
    self.id = id
    self.content = content
  }
  
  convenience init(_ data: Tag) {
    self.init(
      id: data.id,
      content: data.content
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
