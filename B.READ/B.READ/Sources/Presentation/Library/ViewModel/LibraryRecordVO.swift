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
  var state: ReadingState
  var heartCount: Int
  var starCount: Int
  var currentPage: Int
  var percent: Int
  var memoCount: Int
  var quoteCount: Int
  var period: (start: Date?, end: Date?)
  var isFavorite: Bool
  var createdAt: Date

  init(
    id: String,
    isbn: String,
    name: String,
    coverImage: Data? = nil,
    state: ReadingState,
    heartCount: Int,
    starCount: Int,
    currentPage: Int,
    percent: Int,
    memoCount: Int,
    quoteCount: Int,
    period: (start: Date?, end: Date?),
    isFavorite: Bool,
    createdAt: Date
  ) {
    self.id = id
    self.isbn = isbn
    self.name = name
    self.coverImage = coverImage
    self.state = state
    self.heartCount = heartCount
    self.starCount = starCount
    self.currentPage = currentPage
    self.percent = percent
    self.memoCount = memoCount
    self.quoteCount = quoteCount
    self.period = period
    self.isFavorite = isFavorite
    self.createdAt = createdAt
  }
  
  init(record: Record, book: Book) {
    self.id = record.id
    self.isbn = record.isbn
    self.name = book.name
    self.coverImage = book.coverImage
    self.state = ReadingState(rawValue: record.state.rawValue) ?? .reading
    self.heartCount = record.heartCount
    self.starCount = record.starCount
    self.currentPage = record.currentPage
    self.percent = Int(Double(record.currentPage) / Double(book.totalPages) * 100)
    self.memoCount = record.memoIDs.count
    self.quoteCount = record.quoteIDs.count
    self.period = (record.period.startDate, record.period.endDate)
    self.isFavorite = record.isFavorite
    self.createdAt = record.createdAt
  }
}

extension LibraryRecordVO: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: LibraryRecordVO, rhs: LibraryRecordVO) -> Bool {
    return lhs.id == rhs.id
  }
}
