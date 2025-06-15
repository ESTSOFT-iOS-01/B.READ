//
//  GuideDTO.swift
//  B.READ
//
//  Created by 신승재 on 5/30/25.
//

import Foundation
import SwiftData

@Model
final class GuideDTO {
  var date: Date
  var content: String
  
  var memo: MemoDTO?
  
  init(date: Date, content: String) {
    self.date = date
    self.content = content
  }
  
  convenience init(_ data: Guide) {
    self.init(
      date: data.date,
      content: data.content
    )
  }
}

extension GuideDTO {
  func toEntity() -> Guide {
    return Guide(
      date: self.date,
      content: self.content
    )
  }
}
