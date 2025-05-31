//
//  RecordStatsView.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordStatsView
struct RecordStatsView: View {
  
  private let record: RecordCellVO
  
  init(record: RecordCellVO) {
    self.record = record
  }
  
  var body: some View {
    HStack(spacing: 12) {
      switch record.readingState {
      case .notStart: // 기대지수
        PropertyView(LibraryConstants.Icon.heart, record.heart.toString)
      case .reading: // 독서진행률
        PropertyView(LibraryConstants.Icon.progress, record.progress.toString, .percent)
      case .finished: // 평점
        PropertyView(LibraryConstants.Icon.star, record.star.toString)
      }
      PropertyView(LibraryConstants.Icon.memo, "\(record.memoCount)", .count) // 메모
      PropertyView(LibraryConstants.Icon.quote, "\(record.quoteCount)", .count) // 문장
    } // : HStack
    .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
  }
}
