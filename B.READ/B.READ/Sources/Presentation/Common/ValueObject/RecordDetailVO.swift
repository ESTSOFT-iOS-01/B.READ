//
//  RecordDetailVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/31/25.
//

import Foundation
import SwiftUI

/// 독서 기록 상세 조회
// MARK: - (S)RecordDetailVO
struct RecordDetailVO: Identifiable {
  // 공통
  let id: String
  let isbn: String
  // 책정보
  let title: String
  let coverImage: Image?
  // 독서기록
  var readingState: ReadingState
  var heart: Int // 기대지수
  var star: Int // 평점
  var currentPage: Int // 읽은 페이지
  var period: (startDate: Date?, endDate: Date?)
  var isFavorite: Bool
  
  init(
    id: String,
    isbn: String,
    title: String,
    coverImage: Image?,
    readingState: ReadingState,
    heart: Int,
    star: Int,
    currentPage: Int,
    period: (startDate: Date?, endDate: Date?),
    isFavorite: Bool
  ) {
    self.id = id
    self.isbn = isbn
    self.title = title
    self.coverImage = coverImage
    self.readingState = readingState
    self.heart = heart
    self.star = star
    self.currentPage = currentPage
    self.period = period
    self.isFavorite = isFavorite
  }
  
  init(record: Record, book: Book) {
    self.id =  record.id
    self.isbn = record.isbn
    self.title = book.name
    if let imageData = book.coverImage, let image = UIImage(data: imageData) {
      self.coverImage = Image(uiImage: image)
    } else {
      self.coverImage = nil
    }
    self.readingState = ReadingState.fromEntity(record.state)
    self.heart = record.heartCount
    self.star = record.starCount
    self.currentPage = record.currentPage
    self.period = record.period
    self.isFavorite = record.isFavorite
  }
}

extension RecordDetailVO: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: RecordDetailVO, rhs: RecordDetailVO) -> Bool {
    return lhs.id == rhs.id
  }
}
