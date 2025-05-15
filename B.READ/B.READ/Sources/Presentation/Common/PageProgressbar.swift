//
//  Progressbar.swift
//  B.READ
//
//  Created by 심근웅 on 5/15/25.
//

import SwiftUI

enum ProgressState {
  // TODO: 빵 굽기에 맞는 이름으로 변경
  case raw
  case rare
  case medium
  case wellDone
  
  var content: String {
    switch self {
    case .raw:
      return "오븐 예열 중"
    case .rare, .medium, .wellDone:
      return "빵 굽는 중"
    }
  }
  
  var color: Color {
    switch self {
    case .raw:
        .backgroundDefault
    case .rare:
        .brown2
    case .medium:
        .brown3
    case .wellDone:
        .brown4
    }
  }
  
  var image: String {
    switch self {
    case .raw:
      return "Bread0"
    case .rare:
      return "Bread1"
    case .medium:
      return "Bread2"
    case .wellDone:
      return "Bread3"
    }
  }
  
}

// MARK: - (S)PageProgressbar
struct PageProgressbar: View {

  let barHeight: CGFloat = 10 // 프로그래스바 높이
  // TODO: 식빵 이미지로 변경하기
  let breadImage: String = "Bread"
  
  let currentPage: Int = 100 // 현재 페이지
  let totalPage: Int = 500 // 전체 페이지
  let progressState: ProgressState
  
  init() {
    let percent = Double(currentPage) / Double(totalPage) * 100
    
    // 읽은량에 따라서 상태 변화
    if percent == 0 {
      progressState = .raw
    } else if percent > 0 && percent < 33 {
      progressState = .rare
    } else if percent >= 33 && percent < 66 {
      progressState = .medium
    } else {
      progressState = .wellDone
    }
    
  }
  
  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .leading, spacing: 2) {
        HStack {
          Image(breadImage)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(progressState.color)
            .frame(width: 21, height: 20)
            .border(.black, width: 4)
          
          Text(progressState.content)
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
        
        progressbar(totalWidth: proxy.size.width)
          
      } // : VStack
    }
    
  }
  
  // MARK: - (F)progressbar
  @ViewBuilder
  private func progressbar(totalWidth: CGFloat) -> some View {
    ZStack(alignment: .leading) {
      Rectangle()
        .fill(.backgroundDefault)
        .border(.gray2, width: 1)
        .frame(width: totalWidth, height: barHeight)
        .clipShape(RoundedCorner(radius: barHeight/2))
        
      
      Rectangle()
        .fill(progressState.color)
        .frame(width: 100, height: barHeight)
        .clipShape(RoundedCorner(radius: barHeight/2))
    } // : ZStack
    
  }
}

#Preview {
  PageProgressbar()
}

