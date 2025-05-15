//
//  RecentSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

// MARK: - (S)RecentSearchView
struct RecentSearchView: View {
  let keywords: [String]
  
  // 선택된 string 검색창에 입력 처리
  let onSelect: (String) -> Void = { print("\($0)이 선택되었습니다.") }
  
  // 선택된 항목 삭제
  let onDelete: (String) -> Void = { print("\($0)이 삭제됩니다.") }
  let deleteAllKeywords: () -> Void = { print("모든 검색어 삭제") }
  
  var body: some View {
    VStack(spacing: 8) {
      HStack {
        Text("최근 검색어")
          .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1, letterSpacing: -0.025)
          .frame(maxWidth: .infinity, alignment: .leading)
          .foregroundStyle(.gray3)
        
        Button(action: deleteAllKeywords) {
          Text("전체 삭제")
            .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.025)
            .frame(alignment: .trailing)
            .foregroundColor(.gray1)
        }
      } // : Hstack 헤더
    }
  }
}

// MARK: - (S)RecentSearchCell
struct RecentSearchCell: View {
  let keyword: String
  let onSelect: (String) -> Void
  let onDelete: () -> Void
  
  let layoutPadding: CGFloat = 16
  
  var body: some View {
    HStack(spacing: layoutPadding) {
      Text(keyword)
        .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.2, letterSpacing: 0.02)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
        .truncationMode(.tail)
        .foregroundStyle(.brown9)
        .padding(.leading, layoutPadding)
        .background(.red)
      
      Button(action: onDelete) {
        Image(systemName: SearchConstants.Icon.close)
          .font(.system(size: 10, weight: .light))
          .foregroundColor(.gray5)
      }
      .padding(.trailing, 4)
    } // : HStack
    .frame(width: .infinity, height: 48)
    .onTapGesture {
      onSelect(keyword)
    }
  }
}

#Preview {
  RecentSearchView(keywords: ["Test"])
}
