//
//  LibraryListCell.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

// MARK: - (S)LibraryListCell
struct LibraryListCell: View {
  
  private let record: LibraryRecordVO
  private let layoutPadding: CGFloat = 24
  
  init(record: LibraryRecordVO) {
    self.record = record
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      // TODO: - (DB연결 후)Book 표지가 들어갈 자리
      Group {
        if let imageData = record.coverImage, let image = UIImage(data: imageData) {
          Image(uiImage: image)
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
        Text(record.name)
          .lineLimit(2)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1)
        
        // 독서 현황
        RecordStatsView(record: record)
        
        // 독서 기간
        Group {
          if let start = record.period.start?.string(format: .dotSeparated) {
            if let end = record.period.end?.string(format: .dotSeparated) {
              Text("\(start) ~ \(end)")
            } else {
              Text("\(start) ~")
            }
          }
        }
        .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1, letterSpacing: -0.025)
        .foregroundStyle(.brown5)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.top, 11)
      .padding(.leading, layoutPadding)
      .padding(.trailing, record.isFavorite ? 2 : 40)
      
      if record.isFavorite {
        Image(systemName: LibraryConstants.Icon.favoriteON)
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
}


#Preview {
  let record = LibraryRecordVO(
    id: "123",
    isbn: "9788937460586",
    name: "싯다르타",
    coverImage: nil,
    state: .completed,
    heartCount: 0,
    starCount: 4,
    percent: 100,
    memoCount: 4,
    quoteCount: 3,
    period: (
      Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 20)),
      Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))
    ),
    isFavorite: false,
    createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 19))!
  )
  LibraryListCell(record: record)
}
