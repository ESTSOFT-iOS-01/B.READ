//
//  RecentSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

// MARK: - (S)RecentSearchView
struct RecentSearchView: View {
  @ObservedObject var viewModel: RecentSearchViewModel
  @ObservedObject var inputViewModel: SearchInputViewModel
  @ObservedObject var resultViewModel: SearchResultViewModel
  
  var body: some View {
    VStack(spacing: 8) {
      headerView
      if viewModel.keywords.isEmpty {
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
    .animation(.easeInOut(duration: 0.25), value: viewModel.keywords)
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
      ForEach(Array(viewModel.keywords.enumerated()), id: \.offset) { index, keyword in
        RecentSearchCell(
          keyword: keyword,
          onSelect: { _ in
            inputViewModel.searchText = keyword
            viewModel.send(.selectKeyword(keyword))
            inputViewModel.send(.onSubmitSearch)
            resultViewModel.send(.onAppear(keyword))
          },
          onDelete: {
            withAnimation(.easeInOut(duration: 0.25)) {
              viewModel.send(.deleteKeyword(keyword))
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
        Image(systemName: SFSymbol.xmark.name)
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
  //  RecentSearchView(viewModel: SearchViewModel())
  //    .padding(.horizontal, 24)
  // onAppear에서만 더미데이터 들어감
}
