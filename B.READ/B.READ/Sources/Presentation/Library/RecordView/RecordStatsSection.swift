//
//  RecordStatsSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordStatsSection
struct RecordStatsSection: View {
  
  let readState: ReadState
  let period: (start: Date?, end: Date?)
  let currentPage: Int
  let totalPage: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // 기대 지수, 평점
      // TODO: - 기대 지수, 평점 점수판 만들어서 넣기
      Group {
        switch readState {
        case .toRead:
          Text("기대지수")
        case .reading:
          EmptyView()
        case .completed:
          Text("평점")
        }
      } // : Group
      .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 0.95)
      
      // 독서 기간
      VStack(alignment: .leading, spacing: 8) {
        Text("독서 기간")
          .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 0.95)
        
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
  //
  @ViewBuilder
  private func recordPeriodView() -> some View {
    HStack(spacing: 8) {
      switch period {
      case (nil, nil):
        Text("아직 독서를 시작하지 않았어요")
          .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 1.3)
          .foregroundStyle(.green4)
      case (let start, _):
        HStack(spacing: 8) {
          Text("시작")
            .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 1.3)
            .foregroundStyle(.green4)
          Text(start!.string(format: .dotSeparated))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.gray2)
            .brStyleFont(
              .pretendard(.regular, size: 14),
              lineHeight: 1.3,
              letterSpacing: -0.025
            )
          Text("종료")
            .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 1.3)
            .foregroundStyle(.green4)
          Text(period.end?.string(format: .dotSeparated) ?? "")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.gray2)
            .brStyleFont(
              .pretendard(.regular, size: 14),
              lineHeight: 1.3,
              letterSpacing: -0.025
            )
        }
      }
    } // : HStack
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
  }
}
