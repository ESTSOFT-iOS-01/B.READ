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
    HStack(spacing: 0) {
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
        recordStatsSection
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
        
        // 독서 기간
        recordPeriod
          .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1, letterSpacing: -0.025)
          .foregroundStyle(.brown5)
        
      } // : VStack
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.top, 16)
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
  
  // MARK: - (S)recordStatsView
  private var recordStatsSection: some View {
    HStack(spacing: 12) {
      switch record.state {
      case .toRead: // 기대지수
        PropertyView(LibraryConstants.Icon.heart, "\(record.heartCount)")
      case .reading: // 독서진행률
        PropertyView(LibraryConstants.Icon.progress, "\(record.percent)", .percent)
      case .completed: // 평점
        PropertyView(LibraryConstants.Icon.star, "\(record.starCount)")
      }
      PropertyView(LibraryConstants.Icon.memo, "\(record.starCount)", .count) // 메모
      PropertyView(LibraryConstants.Icon.quote, "\(record.starCount)", .count) // 문장
    } // : HStack
  }
  
  // MARK: - (S)recordPeriod
  private var recordPeriod: some View {
    VStack {
      if record.state == .reading {
        let startDay: String = record.period.start!.string(format: .dotSeparated)
        Text("\(startDay) ~")
        
      } else if record.state == .completed {
        let startDay: String = record.period.start!.string(format: .dotSeparated)
        let endDay: String = record.period.start!.string(format: .dotSeparated)
        Text("\(startDay) ~ \(endDay)")
      }
    } // : VStack
  }
}
