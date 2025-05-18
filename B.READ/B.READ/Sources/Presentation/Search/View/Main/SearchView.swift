//
//  SearchView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)SearchView
struct SearchView: View {
  @ObservedObject var viewModel: SearchViewModel
  @State private var isSearchFocused: Bool = false
  @State private var isSearchSubmitted: Bool = false
  private let layoutSize: CGFloat = 16
  
  var body: some View {
    VStack(alignment: .center, spacing: layoutSize) {
      if !isSearchFocused {
        logoView
          .transition(.opacity)
      }
      
      // 검색창은 한 개만 존재해야함
      searchBarSection
        .padding(.top, !isSearchFocused ? 0 : layoutSize)
      
      if isSearchFocused {
        // TODO : DummyData, 추후 뷰모델 연결 필요
        RecentSearchView(keywords: ["Test", "Test", "Test", "Test1", "Test3"])
          .transition(.opacity)
          .frame(maxHeight: .infinity, alignment: .top)
      } else {
        bestSellerSection
          .transition(.opacity)
      }
    }
    .padding(.horizontal, 24)
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    .animation(.easeInOut(duration: 0.25), value: isSearchFocused)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
  
  // MARK: - (S)logoView
  private var logoView: some View {
    Text("로고")
      .frame(width: 200, height: 44)
  }
  
  // MARK: - (S)searchBarSection
  private var searchBarSection: some View {
    HStack(spacing: layoutSize) {
      SearchBar(text: $viewModel.state.searchText, isFocused: $isSearchFocused)
      
      if viewModel.state.searchText.isEmpty {
        SearchButton {
          viewModel.send(.onTapBarcode)
        }
      } else {
        SearchButton(style: .close) {
          viewModel.state.searchText = ""
        }
      }
    } // : Hstack - 검색창 영역
  }
  
  // MARK: - (S)bestSellerSection
  private var bestSellerSection: some View {
    VStack(alignment: .leading, spacing: layoutSize) {
      Text("인기 도서")
        .brStyleFont(.pretendard(.semiBold, size: 18),
                     lineHeight: 1,
                     letterSpacing: -0.025)
        .foregroundStyle(.black)
      
      BestSellerView(bookList: viewModel.state.bookList) { rank, name in
        viewModel.send(.onTapBestSeller(rank: rank, name: name))
      }
    } // : vstack - best seller
  }
}

#Preview {
  SearchView(viewModel: SearchViewModel())
}
