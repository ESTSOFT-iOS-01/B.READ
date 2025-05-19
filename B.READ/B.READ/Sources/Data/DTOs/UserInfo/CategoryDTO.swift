//
//  CategoryDTO.swift
//  B.READ
//
//  Created by 신승재 on 5/16/25.
//

import Foundation
import SwiftData

@Model
final class CategoryDTO {
  var id: Int
  var name: String
  
  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
  
  convenience init(_ data: Category) {
    self.init(
      id: data.id,
      name: data.name
    )
  }
}

extension CategoryDTO {
  func toEntity() -> Category {
    return Category(
      id: self.id,
      name: self.name
    )
  }
}
