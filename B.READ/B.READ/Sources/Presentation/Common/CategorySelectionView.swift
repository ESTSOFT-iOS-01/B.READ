//
//  CategorySelectionView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct CategorySelectionView: View {
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
    }
  }
}

#Preview {
  CategorySelectionView()
}
