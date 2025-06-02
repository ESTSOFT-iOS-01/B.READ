//
//  RecordStatsView.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordStatsView
struct RecordStatsView: View {
  
  @Binding private var record: RecordCellVO
  
  init(record: Binding<RecordCellVO>) {
    self._record = record
  }
  
  var body: some View {
    HStack(spacing: 12) {
      switch record.readingState {
      case .notStart: // 기대지수
        PropertyView(SFSymbol.heart.name, record.heart.toString)
      case .reading: // 독서진행률
        PropertyView(SFSymbol.timer.name, record.progress.toString, .percent)
      case .finished: // 평점
        PropertyView(SFSymbol.star.name, record.star.toString)
      }
      PropertyView(SFSymbol.memo.name, "\(record.memoCount)", .count) // 메모
      PropertyView(SFSymbol.bubble.name, "\(record.quoteCount)", .count) // 문장
    } // : HStack
    .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
  }
}
