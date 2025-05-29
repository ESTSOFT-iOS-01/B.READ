//
//  RecordStatsView.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordStatsView
struct RecordStatsView: View {
  
  private let record: LibraryRecordVO
  
  init(record: LibraryRecordVO) {
    self.record = record
  }
  
  var body: some View {
    HStack(spacing: 12) {
      switch record.state {
      case .toRead: // 기대지수
        PropertyView(LibraryConstants.Icon.heart, "\(record.heartCount)")
      case .reading: // 독서진행률
        PropertyView(LibraryConstants.Icon.progress, "\(record.percent)", .percent)
      case .completed: // 평점
        PropertyView(LibraryConstants.Icon.star, "\(record.starCount)")
      }
      PropertyView(LibraryConstants.Icon.memo, "\(record.memoCount)", .count) // 메모
      PropertyView(LibraryConstants.Icon.quote, "\(record.quoteCount)", .count) // 문장
    } // : HStack
    .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
  }
}
