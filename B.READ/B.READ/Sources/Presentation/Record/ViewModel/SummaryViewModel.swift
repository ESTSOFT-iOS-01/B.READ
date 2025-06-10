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
  @Published var summary: SummaryVO?
  
  init(record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) {
    self.record = record
    self.memos = memos
    self.quotes = quotes
  }
  
}
