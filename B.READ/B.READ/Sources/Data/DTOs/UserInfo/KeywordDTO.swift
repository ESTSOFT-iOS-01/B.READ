//
//  KeywordDTO.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation
import SwiftData

@Model
final class KeywordDTO {
  var date: Date
  var value: String
  
  init(date: Date, value: String) {
    self.date = date
    self.value = value
  }
  
  convenience init(_ data: Keyword) {
    self.init(
      date: data.date,
      value: data.value
    )
  }
}

extension KeywordDTO {
  func toEntity() -> Keyword {
    return Keyword(
      date: self.date,
      value: self.value
    )
  }
}
