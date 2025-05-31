//
//  Book+.swift
//  B.READTests
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation

extension Book: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(isbn)
  }
  
  static func == (lhs: Book, rhs: Book) -> Bool {
    return lhs.isbn == rhs.isbn
  }
}
