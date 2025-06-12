//
//  SortMenu.swift
//  B.READ
//
//  Created by 심근웅 on 5/29/25.
//

import Foundation
import SwiftUI

// TODO: - [시르] 메뉴 등장 및 사라질때 애니메이션 추가하기
// MARK: - (S)SortMenuButton
struct SortMenu: View {
  @Binding var isOpened: Bool
  @Binding var selectedOption: SortOption
  let type: SortTabType
  
  var body: some View {
    Button {
      isOpened = true
    } label: {
      HStack(spacing: 4) {
        Text(isOpened ? "정렬 기준" : selectedOption.rawValue)
          .frame(maxWidth: .infinity, alignment: .center)
        Image(
          systemName: isOpened
          ? SFSymbol.chevronCompactUp.name
          : SFSymbol.chevronCompactDown.name
        )
        .resizable()
        .frame(width: 10 , height: 5, alignment: .trailing)
      } // : HStack
      .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.02)
      .foregroundStyle(.gray2)
    }
    .frame(width: 60, alignment: .trailing)
    .popover(
      isPresented: $isOpened,
      attachmentAnchor: .point(.bottom),
      arrowEdge: .top
    ) {
      sortOptionList()
        .presentationBackground(.clear)
        .presentationCompactAdaptation(.popover)
    }
    .animation(.easeInOut(duration: 0.2), value: isOpened)
  }
  
  // MARK: - (F)SortOptionList
  @ViewBuilder
  private func sortOptionList() -> some View {
    VStack(spacing: 8) {
      ForEach(SortOption.sortMenus(type: type)) { option in
        Button {
          selectedOption = option
          isOpened = false
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
    .shadow(color: .gray2.opacity(0.3), radius: 30, x: 0, y: 2)
  }
}
