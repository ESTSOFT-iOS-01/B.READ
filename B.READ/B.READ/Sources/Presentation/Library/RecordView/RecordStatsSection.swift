//
//  RecordStatsSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordStatsSection
struct RecordStatsSection: View {
  
  private let readState: ReadState
  private let period: (start: Date?, end: Date?)
  private let currentPage: Int
  private let totalPage: Int
  private let heartCount: Int
  private let starCount: Int
  
  private let contentFontSize: CGFloat = 14
  private let layoutPadding: CGFloat = 8
  
  
  init(
    readState: ReadState,
    period: (start: Date?, end: Date?),
    currentPage: Int,
    totalPage: Int,
    heartCount: Int,
    starCount: Int
  ) {
    self.readState = readState
    self.period = period
    self.currentPage = currentPage
    self.totalPage = totalPage
    self.heartCount = heartCount
    self.starCount = starCount
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // 기대 지수, 평점
      if readState == .toRead {
        VStack(alignment: .leading, spacing: 8) {
          Text("기대지수")
          ScoreBoardView(heartCount, type: .heart)
        }
        .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 0.95)
      } else if readState == .completed {
        VStack(alignment: .leading, spacing: 8) {
          Text("평점")
          ScoreBoardView(starCount, type: .star)
        }
        .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 0.95)
      }
      
      // 독서 기간
      VStack(alignment: .leading, spacing: layoutPadding) {
        Text("독서 기간")
          .brStyleFont(
            .pretendard(.semiBold, size: contentFontSize),
            lineHeight: 0.95
          )
        
        recordPeriodView()
          .frame(height: 38)
          .background(.gray0)
          .cornerRadius(8)
      } // : VStack
      
      // 독서 진행률 프로그래스바
      if readState != .completed {
        PageProgressbar(currentPage: currentPage, totalPage: totalPage)
          .frame(height: 28)
      }
    } // : VStack
  }
  
  // MARK: - (F)recordPeriodView
  @ViewBuilder
  private func recordPeriodView() -> some View {
    HStack(spacing: layoutPadding) {
      switch period {
      case (nil, nil):
        Text("아직 독서를 시작하지 않았어요")
          .brStyleFont(
            .pretendard(.semiBold, size: contentFontSize),
            lineHeight: 1.3
          )
          .foregroundStyle(.green4)
      case (let start, _):
        HStack(spacing: layoutPadding) {
          Text("시작")
            .brStyleFont(
              .pretendard(.semiBold, size: contentFontSize),
              lineHeight: 1.3
            )
            .foregroundStyle(.green4)
          Text(start!.string(format: .dotSeparated))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.gray2)
            .brStyleFont(
              .pretendard(.regular, size: contentFontSize),
              lineHeight: 1.3,
              letterSpacing: -0.025
            )
          Text("종료")
            .brStyleFont(
              .pretendard(.semiBold, size: contentFontSize),
              lineHeight: 1.3
            )
            .foregroundStyle(.green4)
          Text(period.end?.string(format: .dotSeparated) ?? "")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.gray2)
            .brStyleFont(
              .pretendard(.regular, size: contentFontSize),
              lineHeight: 1.3,
              letterSpacing: -0.025
            )
        }
      }
    } // : HStack
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, layoutPadding)
    .padding(.horizontal, 16)
  }
}
//
//#Preview {
//  RecordDetailView(viewModel: .init(
//    recordID: DummyData.dummyRecords[2].id,
//    isbn: DummyData.dummyRecords[2].isbn
//  ))
//}
