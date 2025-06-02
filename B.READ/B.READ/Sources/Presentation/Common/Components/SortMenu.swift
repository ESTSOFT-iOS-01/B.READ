//
//  SortMenu.swift
//  B.READ
//
//  Created by 심근웅 on 5/29/25.
//

import Foundation
import SwiftUI

// 정렬을 부르는 탭의 종류
enum SortTabType {
  case library
  case quote
  case memo
}

// 정렬 기준
enum SortOption: String, CaseIterable, Identifiable {
  
  case recent = "최신 순"
  case oldest = "오래된 순"
  case pageAscending = "오름차 순"
  case pageDescending = "내림차 순"
  case titleAscending = "가나다 순"
  case titleDescending = "다나가 순"
  
  // ForEach를 위한 id 추가
  var id: String { self.rawValue }
  
  // 화면에 따른 Option 반환
  static func sortMenus(type: SortTabType) -> [SortOption] {
    switch type {
    case .library: [.recent, .oldest, .titleAscending, .titleDescending]
    case .quote, .memo: [.recent, .oldest]
    }
  }
  
  // RecordCellVO를 쓸때의 정렬
  func sort(_ lhs: RecordCellVO, _ rhs: RecordCellVO) -> Bool {
    switch self {
    case .recent: lhs.createdAt > rhs.createdAt
    case .oldest: lhs.createdAt < rhs.createdAt
    case .titleAscending: lhs.title < rhs.title
    case .titleDescending: lhs.title > rhs.title
    default: true
    }
  }
}

// TODO: - [시르] 메뉴 등장 및 사라질때 애니메이션 추가하기
// MARK: - (S)SortMenuButton
struct SortMenuButton: View {
  @Binding var isOpened: Bool
  @Binding var selectedOption: SortOption
  
  var body: some View {
    Button {
      isOpened.toggle()
    } label: {
      HStack(spacing: 4) {
        Text(isOpened ? "정렬 기준" : selectedOption.rawValue)
          .frame(maxWidth: .infinity, alignment: .center)
        Image(systemName: isOpened ? "chevron.compact.up" : "chevron.compact.down")
          .resizable()
          .frame(width: 10 , height: 5, alignment: .trailing)
      } // : HStack
      .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.02)
      .foregroundStyle(.gray2)
    }
    .frame(width: 60, alignment: .trailing)
  }
}

// MARK: - (S)SortMenu
struct SortMenu: View {
  var type: SortTabType
  @Binding var isOpened: Bool
  @Binding var selectedOption: SortOption
  
  var body: some View {
    ZStack {
      VStack(spacing: 8) {
        ForEach(SortOption.sortMenus(type: type)) { option in
          Button {
            selectedOption = option
            DispatchQueue.main.async { isOpened.toggle() }
          } label: {
            Text(option.rawValue)
              .foregroundStyle(selectedOption == option ? .black : .gray2)
              .brStyleFont(
                .pretendard(selectedOption == option ? .semiBold : .medium, size: 12),
                lineHeight: 1.0,
                letterSpacing: -0.02
              )
          }
        }
      } // : VStack
      .padding(16)
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .shadow(color: .gray2.opacity(0.25), radius: 25, x: 0, y: 2)
    }
  }
}
