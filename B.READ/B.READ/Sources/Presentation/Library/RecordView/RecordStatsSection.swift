//
//  RecordStatsSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

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
        // TODO: - 독서 기간 컴포넌트 제작해서 넣기
        //        recordPeriodView(start: viewModel.state.info?.record.period)
        Rectangle()
          .fill(.gray0)
          .frame(height: 38)
          .frame(maxWidth: .infinity)
          .cornerRadius(8)
      } // : VStack
      
      // 독서 진행률 프로그래스바
      if readState != .completed {
        PageProgressbar(currentPage: currentPage, totalPage: totalPage)
          .frame(height: 28)
      }
    } // : VStack
  }
}
