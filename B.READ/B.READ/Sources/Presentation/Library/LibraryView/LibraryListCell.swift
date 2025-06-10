//
//  LibraryListCell.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

// MARK: - (S)LibraryListCell
struct LibraryListCell: View {
  
  @Binding var record: RecordCellVO
  private let layoutPadding: CGFloat = 24
  
  var body: some View {
    HStack(alignment: .top, spacing: 0) {

      coverImage()
      .frame(width: 57, height: 88)
      .cornerRadius(6)
      
      VStack(alignment: .leading, spacing: 6) {
        // 도서 제목
        Text(record.title)
          .lineLimit(2)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
        
        // 독서 현황
        // TODO: - [시르] Binding으로 만들어야하면, 제작해서 사용
        RecordPropertyRow(data: record)
//        RecordStatsView(record: $record)
        
        // 독서 기간
        periodView(record.period)
        .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1, letterSpacing: -0.025)
        .foregroundStyle(.brown5)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.top, 11)
      .padding(.leading, layoutPadding)
      .padding(.trailing, record.isFavorite ? 2 : 40)
      
      if record.isFavorite {
        Image(systemName: SFSymbol.bookMarkFill.name)
          .resizable()
          .foregroundStyle(.green4)
          .frame(width: 14, height: 28)
          .frame(maxHeight: .infinity, alignment: .top)
      }
    } // : HStack
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, layoutPadding)
    .padding(.vertical, 13) // 114(전체높이) - 88(사진높이) = 26 / 2 = 13 => 내부 요소로 높이 맞추기
  }
  
  // MARK: - (F)periodView
  @ViewBuilder
  private func periodView(_ period: (startDate: Date?, endDate: Date?)) -> some View {
    if let start = period.startDate?.string(format: .dotSeparated) {
      if let end = period.endDate?.string(format: .dotSeparated) {
        Text("\(start) ~ \(end)")
      } else {
        Text("\(start) ~")
      }
    }
  }
  
  // MARK: - (F)coverImage
  @ViewBuilder
  private func coverImage() -> some View {
    if let coverImage = record.coverImage {
      coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
    } else {
      Image(.exampleCover)
        .resizable()
        .aspectRatio(contentMode: .fill)
    }
  }
}

#Preview {
  @Previewable @State var record = RecordCellVO(
    record: DummyData.dummyRecords[1],
    book: DummyData.dummyBooks[1]
  )
  PreviewableContainer {
    LibraryListCell(record: $record)
  }
}
