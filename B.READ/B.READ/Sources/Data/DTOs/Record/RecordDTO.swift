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
  var summaryID: String?
  var memoIDs: [String]
  var quoteIDs: [String]
  var createdAt: Date
  var updatedAt: Date
  
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
    summaryID: String? = nil,
    memoIDs: [String],
    quoteIDs: [String],
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
    self.summaryID = summaryID
    self.memoIDs = memoIDs
    self.quoteIDs = quoteIDs
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
      summaryID: data.summaryID,
      memoIDs: data.memoIDs,
      quoteIDs: data.quoteIDs,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt
    )
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
      summaryID: self.summaryID,
      memoIDs: self.memoIDs,
      quoteIDs: self.quoteIDs,
      createdAt: self.createdAt,
      updatedAt: self.updatedAt
    )
  }
}
