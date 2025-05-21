//
//  Record+.swift
//  B.READTests
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation

extension Record: Equatable {
  static func == (lhs: Record, rhs: Record) -> Bool {
    if lhs.id != rhs.id { return false }
    if lhs.isbn != rhs.isbn { return false }
    if lhs.state != rhs.state { return false }
    if lhs.heartCount != rhs.heartCount { return false }
    if lhs.starCount != rhs.starCount { return false }
    if lhs.isFavorite != rhs.isFavorite { return false }
    if lhs.period.0 != rhs.period.0 { return false }
    if lhs.period.1 != rhs.period.1 { return false }
    if lhs.currentPage != rhs.currentPage { return false }
    if lhs.review != rhs.review { return false }
    if lhs.summaryID != rhs.summaryID { return false }
    if lhs.memoIDs != rhs.memoIDs { return false }
    if lhs.quoteIDs != rhs.quoteIDs { return false }
    if lhs.createdAt != rhs.createdAt { return false }
    if lhs.updatedAt != rhs.updatedAt { return false }
    
    return true
  }
}
