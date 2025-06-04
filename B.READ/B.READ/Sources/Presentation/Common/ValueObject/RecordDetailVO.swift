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
  let author: String
  let totalPage: Int
  // 독서기록
  var readingState: ReadingState
  var heart: Int // 기대지수
  var star: Int // 평점
  var currentPage: Int // 읽은 페이지
  var review: String // 한줄평
  var period: (startDate: Date?, endDate: Date?)
  var isFavorite: Bool
  var createdAt: Date
  
  init(
    id: String,
    isbn: String,
    title: String,
    coverImage: Image?,
    author: String,
    totalPage: Int,
    readingState: ReadingState,
    heart: Int,
    star: Int,
    currentPage: Int,
    review: String,
    period: (startDate: Date?, endDate: Date?),
    isFavorite: Bool,
    createdAt: Date
  ) {
    self.id = id
    self.isbn = isbn
    self.title = title
    self.coverImage = coverImage
    self.author = author
    self.totalPage = totalPage
    self.readingState = readingState
    self.heart = heart
    self.star = star
    self.currentPage = currentPage
    self.review = review
    self.period = period
    self.isFavorite = isFavorite
    self.createdAt = createdAt
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
    self.author = book.author
    self.totalPage = book.totalPages
    self.readingState = ReadingState.fromEntity(record.state)
    self.heart = record.heartCount
    self.star = record.starCount
    self.currentPage = record.currentPage
    self.review = record.review
    self.period = record.period
    self.isFavorite = record.isFavorite
    self.createdAt = record.createdAt
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

extension RecordDetailVO {
  // TODO: - [시르] 아이디어 필요! VO에 메모, 문장을 넣는방법도 있음
  func toEntity(memos: [MemoVO], quotes: [QuoteVO]) -> Record {
    Record(
      id: self.id,
      isbn: self.isbn,
      state: self.readingState.toEntity(),
      heartCount: self.heart,
      starCount: self.star,
      isFavorite: self.isFavorite,
      period: self.period,
      currentPage: self.currentPage,
      review: self.review,
      memos: memos.map { $0.toEntity() },
      quotes: quotes.map { $0.toEntity() },
      createdAt: self.createdAt,
      updatedAt: Date()
    )
  }
}
