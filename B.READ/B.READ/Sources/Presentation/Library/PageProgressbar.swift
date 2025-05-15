//
//  Progressbar.swift
//  B.READ
//
//  Created by 심근웅 on 5/15/25.
//

import SwiftUI

// MARK: - (S)PageProgressbar
struct PageProgressbar: View {

  private let barHeight: CGFloat = 4 // 프로그래스바 높이(실제로 적용했을때 높이가 낮은거 같으면 늘리기)
  let currentPage: Int // 현재 페이지
  let totalPage: Int // 전체 페이지
  private var percent: Double { // 독서 진행률
    Double(currentPage) / Double(totalPage)
  }
  private var progressState: ProgressState {
    switch percent {
    case 0:
        .raw
    case ..<0.33:
        .rare
    case 0.33..<0.66:
        .medium
    default:
        .wellDone
    }
  }
  
  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .leading, spacing: 2) {
        progressHeader()
        
        progressbar(totalWidth: proxy.size.width)
      } // : VStack
    } // : GeometryReader
    
  }
  
  // MARK: - (F)content
  @ViewBuilder
  private func progressHeader() -> some View {
    HStack {
      progressState.image
        .resizable()
        .frame(width: 21, height: 20)
      
      Text(progressState.label)
        .brStyleFont(
          .pretendard(.semiBold, size: 14),
          lineHeight: 1
        )
      
      Text("\(currentPage) / \(totalPage) 페이지")
        .brStyleFont(
          .pretendard(.regular, size: 12),
          lineHeight: 1
        )
        .frame(maxWidth: .infinity, alignment: .trailing)
        .foregroundStyle(.gray3)
    } // : HStack
  }
  
  // MARK: - (F)progressbar
  @ViewBuilder
  private func progressbar(totalWidth: CGFloat) -> some View {
    ZStack(alignment: .leading) {
      
      Rectangle()
        .fill(.backgroundDefault)
        .border(.gray2, width: 1)
        .frame(width: totalWidth, height: barHeight)
        .clipShape(.capsule)
        
      Rectangle()
        .fill(progressState.color)
        .frame(width: totalWidth * percent, height: barHeight)
        .clipShape(.capsule)
    } // : ZStack
  }
  
}

#Preview {
  VStack(spacing: 20) {
    PageProgressbar(currentPage: 0, totalPage: 300)
    PageProgressbar(currentPage: 80, totalPage: 300)
    PageProgressbar(currentPage: 180, totalPage: 300)
    PageProgressbar(currentPage: 280, totalPage: 300)
  }
  .frame(height: 200)
  .padding(.horizontal, 20)
}
