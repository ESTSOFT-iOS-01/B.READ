//
//  RecentSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

// MARK: - (S)RecentSearchView
struct RecentSearchView: View {
  @ObservedObject var viewModel: SearchViewModel
  
  var body: some View {
    VStack(spacing: 8) {
      headerView
      if viewModel.state.keywordList.isEmpty {
        Text("최근 검색어가 없습니다.")
          .foregroundStyle(.gray7)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.0, letterSpacing: -0.025)
          .transition(.opacity)
          .padding(.vertical, 16)
      } else {
        listView
          .transition(.opacity)
      }
    }
    .animation(.easeInOut(duration: 0.25), value: viewModel.state.keywordList)
  }
  
  // MARK: - (S)headerView
  private var headerView: some View {
    HStack {
      Text("최근 검색어")
        .brStyleFont(.pretendard(.medium, size: 14),
                     lineHeight: 1,
                     letterSpacing: -0.025)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.gray3)
      
      Button {
        withAnimation(.easeInOut(duration: 0.25)) {
          viewModel.send(.deleteAllKeywords)
        }
      } label: {
        Text("전체 삭제")
          .brStyleFont(.pretendard(.medium, size: 12),
                       lineHeight: 1,
                       letterSpacing: -0.025)
          .frame(alignment: .trailing)
          .foregroundColor(.gray1)
      }
    }
  }
  
  // MARK: - (S)listView
  private var listView: some View {
    VStack {
      ForEach(Array(viewModel.state.keywordList.enumerated()), id: \.offset) { index, keyword in
        RecentSearchCell(
          keyword: keyword,
          onSelect: { _ in
            viewModel.send(.selectKeyword(keyword))
          },
          onDelete: {
            withAnimation(.easeInOut(duration: 0.25)) {
              viewModel.send(.deleteKeyword(at: index))
            }
          }
        )
        .transition(.opacity)
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

//#Preview {
//  RecentSearchView(keywords: ["Test", "Test1", "Test3"])
//    .padding(.horizontal, 24)
//}
