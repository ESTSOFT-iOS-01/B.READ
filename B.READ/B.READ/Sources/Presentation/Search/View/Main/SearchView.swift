//
//  SearchView.swift
//  B.READ
//
//  Created by 김도연 on 5/11/25.
//

import SwiftUI

// MARK: - (S)SearchView
struct SearchView: View {
  @StateObject var viewModel: SearchViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  private let layoutSize: CGFloat = 16
  private let horizontalPadding: CGFloat = 24
  
  init(viewModel: SearchViewModel) {
    self._viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: layoutSize) {
      if !viewModel.isSearchFocused && !viewModel.isSearchSubmitted {
        logoView
          .transition(.opacity)
      }
      
      // 검색창은 한 개만 존재해야함
      searchBarSection
        .padding(
          .top,
          viewModel.isSearchFocused || viewModel.isSearchSubmitted ? layoutSize : 0)
      
      Group {
        if viewModel.isSearchFocused {
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
            .environmentObject(coordinator)
            .transition(.opacity)
            .padding(.horizontal, horizontalPadding)
        }
      }
    }
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    .animation(.easeInOut(duration: 0.3), value: viewModel.isSearchFocused || viewModel.isSearchSubmitted)
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
      SearchBar(
        text: $viewModel.searchText,
        isFocused: $viewModel.isSearchFocused,
        onSubmit: {
          if !viewModel.searchText.isEmpty {
            viewModel.send(.onSubmitSearch)
          }
        })
      
      if viewModel.searchText.isEmpty {
        SearchButton {
          coordinator.push(.barcode)
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
      
      BestSellerView(bookList: viewModel.bestBookList) { book in
        coordinator.push(.searchBook(isbn: book.isbn))
      }
    } // : vstack - best seller
  }
}

//#Preview {
//  SearchView(viewModel: SearchViewModel())
//}
