//
//  SummaryViewModel.swift
//  B.READ
//
//  Created by 김도연 on 6/10/25.
//

import Foundation
import SwiftUI

final class SummaryViewModel: ObservableObject {
  let record: RecordDetailVO
  let memos: [MemoVO]
  let quotes: [QuoteVO]
  @Published var summary: SummaryVO
  @Published var memoData: [String] = []
  @Published var quoteData: [String] = []
  
  init(record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) {
    self.record = record
    self.memos = memos
    self.quotes = quotes
    
    memoData = memos.extractContents()
    quoteData = quotes.extractContents()
    
    summary = SummaryVO(DummyData.summaryForFetchTest)
  }
  
}

extension Array where Element == MemoVO {
  func extractContents() -> [String] {
    self.map { $0.content }
  }
}

extension Array where Element == QuoteVO {
  func extractContents() -> [String] {
    self.map { $0.content }
  }
}
