//
//  LibraryGridCell.swift
//  B.READ
//
//  Created by 심근웅 on 6/4/25.
//

import Foundation
import SwiftUI

struct LibraryGridCell: View {
  
  @Binding var record: RecordCellVO
  private let layoutPadding: CGFloat = 8
  
  var body: some View {
    VStack(spacing: layoutPadding) {
      ZStack(alignment: .topTrailing) {
        Group {
          if let coverImage = record.coverImage {
            coverImage
              .resizable()
              .aspectRatio(contentMode: .fill)
          } else {
            Image(.exampleBook)
              .resizable()
              .aspectRatio(contentMode: .fill)
          }
        }
        .frame(width: 88, height: 142, alignment: .top)
        .cornerRadius(6)
        
        if record.isFavorite {
          Image(systemName: SFSymbol.bookMarkFill.name)
            .resizable()
            .frame(width: 14, height: 28)
            .foregroundStyle(.green4)
            .padding(.trailing, layoutPadding)
        }
      } // : ZStack
      
      RecordInfoView()
//      RecordStatsView(record: record)
    } // : VStack
  }
  
  @ViewBuilder
  private func RecordInfoView() -> some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 12) {
        PropertyView(SFSymbol.memo.name, "\(record.memoCount)", .count) // 메모
        PropertyView(SFSymbol.bubble.name, "\(record.quoteCount)", .count) // 문장
      }
      switch record.readingState {
      case .notStart: // 기대지수
        PropertyView(SFSymbol.heart.name, record.heart.toString)
      case .reading: // 독서진행률
        PropertyView(SFSymbol.timer.name, record.progress.toString, .percent)
      case .finished: // 평점
        PropertyView(SFSymbol.star.name, record.star.toString)
      }
    }
  }
}

#Preview {
  @Previewable @State var record = RecordCellVO(
    record: DummyData.dummyRecords[1],
    book: DummyData.dummyBooks[1]
  )
  PreviewableContainer {
    LibraryGridCell(record: $record)
  }
}
