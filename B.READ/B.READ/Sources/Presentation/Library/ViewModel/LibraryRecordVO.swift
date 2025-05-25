//
//  LibraryRecordVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/22/25.
//

import Foundation
import SwiftUI

// MARK: - (S)LibraryRecordVO
struct LibraryRecordVO: Identifiable {
  let id: String
  let isbn: String
  let name: String
  var coverImage: Data?
  var state: ReadState
  var heartCount: Int
  var starCount: Int
  var percent: Int
  var memoCount: Int
  var quoteCount: Int
  var period: (start: Date?, end: Date?)
  var isFavorite: Bool
  var createdAt: Date
}

extension LibraryRecordVO: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: LibraryRecordVO, rhs: LibraryRecordVO) -> Bool {
    return lhs.id == rhs.id
  }
}
