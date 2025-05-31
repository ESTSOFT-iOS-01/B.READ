//
//  RecordCellVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/31/25.
//

import Foundation
import SwiftUI

/// 리스트(그리드) 셀 정보(요약) - 프리뷰
// MARK: - (S)RecordCellVO
struct RecordCellVO: Identifiable {
  // 공통
  let id: String
  let isbn: String
  // 책정보
  let title: String
  let coverImage: Image?
  // 독서기록
  var readingState: ReadingState = .notStart
  var heart: Int = 0 // 기대지수
  var progress: Int = 0 // 진행률
  var star: Int = 0 // 평점
  var memoCount: Int = 0
  var quoteCount: Int = 0
  var period: (startDate: Date?, endDate: Date?) // 독서 기간
  var isFavorite: Bool
  var createdAt: Date
  
  init(
    id: String,
    isbn: String,
    title: String,
    coverImage: Image?,
    readingState: ReadingState,
    heart: Int,
    progress: Int,
    star: Int,
    memoCount: Int,
    quoteCount: Int,
    period: (startDate: Date?, endDate: Date?),
    isFavorite: Bool,
    createdAt: Date
  ) {
    self.id = id
    self.isbn = isbn
    self.title = title
    self.coverImage = coverImage
    self.readingState = readingState
    self.heart = heart
    self.progress = progress
    self.star = star
    self.memoCount = memoCount
    self.quoteCount = quoteCount
    self.period = period
    self.isFavorite = isFavorite
    self.createdAt = createdAt
  }
  
  init(record: Record, book: Book) {
    self.id = record.id
    self.isbn = record.isbn
    self.title = book.name
    if let imageData = book.coverImage, let image = UIImage(data: imageData) {
      self.coverImage = Image(uiImage: image)
    } else {
      self.coverImage = nil
    }
    self.readingState = ReadingState.fromEntity(record.state)
    self.heart = record.heartCount
    self.progress = Int(record.currentPage / book.totalPages)
    self.star = record.starCount
    self.memoCount = record.memoIDs.count
    self.quoteCount = record.quoteIDs.count
    self.period = record.period
    self.isFavorite = record.isFavorite
    self.createdAt = record.createdAt
  }
}

extension RecordCellVO: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: RecordCellVO, rhs: RecordCellVO) -> Bool {
    return lhs.id == rhs.id
  }
}
