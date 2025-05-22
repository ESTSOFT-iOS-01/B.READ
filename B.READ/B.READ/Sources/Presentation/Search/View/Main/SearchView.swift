//
//  SearchView.swift
//  B.READ
//
//  Created by 김도연 on 5/11/25.
//

import SwiftUI

// MARK: - (S)SearchView
struct SearchView: View {
  @ObservedObject var viewModel: SearchViewModel
  private let layoutSize: CGFloat = 16
  private let horizontalPadding: CGFloat = 24
  
  var body: some View {
    NavigationStack(path: $viewModel.coordinator.path) {
      VStack(alignment: .center, spacing: layoutSize) {
        if !viewModel.state.isSearchFocused && !viewModel.state.isSearchSubmitted {
          logoView
            .transition(.opacity)
        }
        
        // 검색창은 한 개만 존재해야함
        searchBarSection
          .padding(
            .top,
            viewModel.state.isSearchFocused || viewModel.state.isSearchSubmitted ? layoutSize : 0)
        
        Group {
          if viewModel.state.isSearchFocused {
            RecentSearchView(viewModel: viewModel)
              .transition(.opacity)
              .frame(maxHeight: .infinity, alignment: .top)
              .padding(.horizontal, horizontalPadding)
            
          } else if viewModel.state.isSearchSubmitted {
            SearchResultView(viewModel: viewModel)
              .transition(.opacity)
              .frame(maxHeight: .infinity, alignment: .top)
            
          } else {
            bestSellerSection
              .transition(.opacity)
              .padding(.horizontal, horizontalPadding)
          }
        }
        
      }
      .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
      .toolbar(viewModel.state.isSearchFocused ? .hidden : .visible, for: .tabBar)
      .animation(.easeInOut(duration: 0.3), value: viewModel.state.isSearchFocused || viewModel.state.isSearchSubmitted)
      .onAppear {
        viewModel.send(.onAppear)
      }
      .navigationDestination(for: SearchAppScene.self) { scene in
        viewModel.coordinator.buildPage(scene)
      }
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
      SearchBar(
        text: $viewModel.state.searchText,
        isFocused: $viewModel.state.isSearchFocused,
        onSubmit: {
          if !viewModel.state.searchText.isEmpty {
            viewModel.send(.onSubmitSearch)
          }
        })
      
      if viewModel.state.searchText.isEmpty {
        SearchButton {
          viewModel.send(.onTapBarcode)
        }
      } else {
        SearchButton(style: .close) {
          viewModel.send(.onTapClear)
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
      
      BestSellerView(bookList: viewModel.state.bestBookList) { rank, name in
        viewModel.send(.onTapBestSeller(rank: rank, name: name))
      }
    } // : vstack - best seller
  }
}

//#Preview {
//  SearchView(viewModel: SearchViewModel())
//}
