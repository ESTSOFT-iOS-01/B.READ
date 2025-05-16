//
//  CategorySelectionView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct CategorySelectionView: View {
  
  private var isButtonEnabled = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("관심 분야를 선택해 주세요.")
        .foregroundStyle(.black)
        .brStyleFont(.pretendard(.semiBold, size: 24), lineHeight: 1.4)
        .padding(.top, 24)
        .padding(.leading, 6)
      
      Text("선택한 분야에 맞는 도서를 추천해 드려요 (2개 선택)")
        .foregroundStyle(.gray5)
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.35)
        .padding(.leading, 6)
      
      CategoryListView()
        .padding(.top, 24)
      
      BottomButton(
        buttonTitle: "저장하기",
        textColor: isButtonEnabled ?  .backgroundDefault : .gray3,
        buttonColor: isButtonEnabled ? .brown3 : .gray0
      ) {
        print("next")
      }
      .disabled(!isButtonEnabled)
      .padding(.horizontal, 6)
      .padding(.top, 12)
      
    }
    .padding(.horizontal, 24)
  }
}

// MARK: - (S)CategoryListView
private struct CategoryListView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        ForEach(Category.allCases, id: \.self) { category in
          Button {
            print("select\(category)")
          } label: {
            HStack(spacing: 16) {
              Image(systemName: "checkmark")
                .resizable()
                .frame(width: 14, height: 11)
                .foregroundStyle(.gray1)
              Text(category.displayName)
                .foregroundStyle(.black)
                .brStyleFont(.pretendard(.medium, size: 18), lineHeight: 1.35, letterSpacing: 0.02)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }
      }
    }.scrollIndicators(.never)
  }
}

#Preview {
  CategorySelectionView()
}
