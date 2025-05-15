//
//  RecentSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

// MARK: - (S)RecentSearchView
struct RecentSearchView: View {
  var keywords: [String] // TODO : 서치뷰에서 state변수와 연결
  
  // 선택된 string 검색창에 입력 처리
  let onSelect: (String) -> Void = { print("\($0)이 선택되었습니다.") }
  
  // 선택된 항목 삭제
  let onDelete: (Int) -> Void = { print("\($0)이 삭제됩니다.") }
  let deleteAllKeywords: () -> Void = { print("모든 검색어 삭제") }
  
  var body: some View {
    VStack(spacing: 8) {
      headerView
      VStack {
        ForEach(Array(keywords.enumerated()), id: \.offset) { index, keyword in
          RecentSearchCell(
            keyword: keyword,
            onSelect: { _ in onSelect(keyword) },
            onDelete: {
              withAnimation(.easeInOut(duration: 0.25)) {
                onDelete(index)
              }
            }
          )
          .transition(.move(edge: .trailing).combined(with: .opacity))
        }
      }
    }
    .animation(.easeInOut(duration: 0.25), value: keywords)
  }
  
  // MARK: - (F)headerView
  private var headerView: some View {
    HStack {
      Text("최근 검색어")
        .brStyleFont(.pretendard(.medium, size: 14),
                     lineHeight: 1,
                     letterSpacing: -0.025)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.gray3)
      
      Button(action: deleteAllKeywords) {
        Text("전체 삭제")
          .brStyleFont(.pretendard(.medium, size: 12),
                       lineHeight: 1,
                       letterSpacing: -0.025)
          .frame(alignment: .trailing)
          .foregroundColor(.gray1)
      }
    }
  }
}

// MARK: - (S)RecentSearchCell
struct RecentSearchCell: View {
  let keyword: String
  let onSelect: (String) -> Void
  let onDelete: () -> Void
  
  private let layoutPadding: CGFloat = 16
  
  var body: some View {
    HStack(spacing: layoutPadding) {
      Text(keyword)
        .brStyleFont(.pretendard(.medium, size: 14),
                     lineHeight: 1.2,
                     letterSpacing: 0.02)
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        .lineLimit(1)
        .truncationMode(.tail)
        .foregroundStyle(.brown9)
        .padding(.leading, layoutPadding)
      
      Button(action: onDelete) {
        Image(systemName: SearchConstants.Icon.close)
          .font(.system(size: 12, weight: .light))
          .foregroundColor(.gray5)
      }
      .padding(.trailing, 4)
    } // : HStack
    .frame(maxWidth: .infinity)
    .frame(height: 48)
    .onTapGesture {
      onSelect(keyword)
    }
  }
}

#Preview {
  RecentSearchView(keywords: ["Test", "Test1", "Test3"])
    .padding(.horizontal, 24)
}
