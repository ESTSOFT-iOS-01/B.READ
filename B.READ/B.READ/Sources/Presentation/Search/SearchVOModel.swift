//
//  SearchVOModel.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

struct BestSellerVO {
  let isbn: String
  let title: String
}

extension BestSellerVO: Identifiable {
  var id: String { isbn }
}

struct BookVO {
  let isbn: String
  let coverImage: Image
  let title: String
  let author: String
  let publisher: String
  let publishedDate: Date
}

extension BookVO: Identifiable {
  var id: String { isbn }
}

struct RecordVO {
  let isbn: String
  let coverImage: Image
  let id: String
  let title: String
  var state: ReadingState = .notStart
  
  var memoCount: Int = 0
  var quoteCount: Int = 0
  var rate: Double = 1.0
  var expectation : Double = 2.0
  var progress: Int = 1
  
  var startDate: Date?
  var endDate: Date?
}

extension RecordVO: Identifiable {}

enum ReadingState {
  case notStart
  case reading
  case finished
}
