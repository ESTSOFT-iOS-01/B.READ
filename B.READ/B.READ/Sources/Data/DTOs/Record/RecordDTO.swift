//
//  RecordDTO.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import SwiftData

@Model
final class RecordDTO {
  
  @Attribute(.unique) var id: String
  var isbn: String
  var state: Int
  var heartCount: Int
  var starCount: Int
  var isFavorite: Bool
  var startDate: Date?
  var endDate: Date?
  var currentPage: Int
  var review: String
  var createdAt: Date
  var updatedAt: Date
  
  @Relationship(deleteRule: .cascade, inverse: \SummaryDTO.record)
  var summary: SummaryDTO?
  
  @Relationship(deleteRule: .cascade, inverse: \MemoDTO.record)
  var memos: [MemoDTO]
  
  @Relationship(deleteRule: .cascade, inverse: \QuoteDTO.record)
  var quotes: [QuoteDTO]
  
  init(
    id: String,
    isbn: String,
    state: Int,
    heartCount: Int,
    starCount: Int,
    isFavorite: Bool,
    period: (startDate: Date?, endDate: Date?) = (nil, nil),
    currentPage: Int,
    review: String,
    summary: SummaryDTO? = nil,
    memos: [MemoDTO],
    quotes: [QuoteDTO],
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.isbn = isbn
    self.state = state
    self.heartCount = heartCount
    self.starCount = starCount
    self.isFavorite = isFavorite
    self.startDate = period.startDate
    self.endDate = period.endDate
    self.currentPage = currentPage
    self.review = review
    self.summary = summary
    self.memos = memos
    self.quotes = quotes
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
  
  convenience init(_ data: Record) {
    self.init(
      id: data.id,
      isbn: data.isbn,
      state: data.state.rawValue,
      heartCount: data.heartCount,
      starCount: data.starCount,
      isFavorite: data.isFavorite,
      period: data.period,
      currentPage: data.currentPage,
      review: data.review,
      summary: nil,
      memos: [],
      quotes: [],
      createdAt: data.createdAt,
      updatedAt: data.updatedAt
    )
    
    self.summary = data.summary.map { SummaryDTO($0, record: self) }
    self.memos = data.memos.map{ MemoDTO($0, record: self) }
    self.quotes = data.quotes.map { QuoteDTO($0, record: self) }
  }
}

extension RecordDTO {
  func toEntity() -> Record {
    return Record(
      id: self.id,
      isbn: self.isbn,
      state: ReadState(rawValue: self.state) ?? .toRead,
      heartCount: self.heartCount,
      starCount: self.starCount,
      isFavorite: self.isFavorite,
      period: (self.startDate, self.endDate),
      currentPage: self.currentPage,
      review: self.review,
      summary: self.summary?.toEntity(),
      memos: self.memos.map { $0.toEntity() },
      quotes: self.quotes.map { $0.toEntity() },
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}
