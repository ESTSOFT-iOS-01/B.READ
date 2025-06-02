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
      // TODO: - (DB연결 후)Book 표지가 들어갈 자리
      Group {
        if let coverImage = record.coverImage {
          coverImage
            .resizable()
        } else {
          // TODO: - 사진이 없을때, 들어갈 이미지 or 도형 추가
          Rectangle()
            .fill(.red.opacity(0.2))
        }
      } // : Group
      .frame(width: 57, height: 88)
      .cornerRadius(6)
      
      VStack(alignment: .leading, spacing: 6) {
        // 도서 제목
        Text(record.title)
          .lineLimit(2)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
        
        // 독서 현황
        RecordStatsView(record: record)
        
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
}
//
//#Preview {
//  @Previewable @State var record = RecordCellVO(
//    record: DummyData.dummyRecords[2],
//    book: DummyData.dummyBooks[2]
//  )
//  LibraryListCell(record: $record)
//}
