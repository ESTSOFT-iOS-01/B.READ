//
//  RecentSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

struct RecentSearchView: View {
  let keywords: [String]
  let onSelect: (String) -> Void
  let onDelete: (String) -> Void
  
  var body: some View {
    VStack(spacing: 8) {
      HStack {
        Text("최근 검색어")
          .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1, letterSpacing: -0.025)
          .frame(alignment: .leading)
          .foregroundStyle(.gray3)
        
        Spacer()
      }
    }
  }
}

struct RecentSearchCell: View {
  let keyword: String
  let onSelect: (String) -> Void
  let onDelete: () -> Void
  
  var body: some View {
    HStack {
      Text(keyword)
        .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.2, letterSpacing: 0.02)
        .frame(alignment: .leading)
        .lineLimit(1)
        .truncationMode(.tail)
        .foregroundStyle(.brown9)
        .padding(.leading, 16)

      Spacer(minLength: 16)
      
      Button(action: onDelete) {
        Image(systemName: SearchConstants.Icon.close)
          .font(.system(size: 10, weight: .light))
          .foregroundColor(.gray5)
      }
      .padding(.trailing, 4)
    }
    .frame(width: .infinity, height: 48)
    .onTapGesture {
      onSelect(keyword)
    }
  }
}

#Preview {

}
