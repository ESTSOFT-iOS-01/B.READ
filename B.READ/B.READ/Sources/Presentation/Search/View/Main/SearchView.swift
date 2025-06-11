//
//  SearchView.swift
//  B.READ
//
//  Created by 김도연 on 5/11/25.
//

import SwiftUI
import Foundation

// MARK: - (S)SearchView
struct SearchView: View {
  @StateObject private var inputViewModel = SearchInputViewModel()
  @StateObject private var resultViewModel = SearchResultViewModel()
  @StateObject private var recentSearchViewModel = RecentSearchViewModel()
  @StateObject private var bestSellerViewModel = BestSellerViewModel()
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  private let layoutSize: CGFloat = 16
  private let horizontalPadding: CGFloat = 24
  
  var body: some View {
    VStack(alignment: .center, spacing: layoutSize) {
      
      if !inputViewModel.isFocused && !inputViewModel.isSubmitted {
        LogoView()
          .transition(.opacity)
      }
      
      // 검색창은 한 개만 존재해야함
      searchBarSection
        .padding(.top, inputViewModel.isFocused || inputViewModel.isSubmitted ? layoutSize : 0)
        .padding(.horizontal, horizontalPadding)
      
      SearchContentView(
        inputViewModel: inputViewModel,
        recentSearchViewModel: recentSearchViewModel,
        resultViewModel: resultViewModel,
        bestSellerViewModel: bestSellerViewModel,
        layoutSize: layoutSize,
        horizontalPadding: horizontalPadding
      )
      
    }
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    .animation(
      .easeInOut(duration: 0.3),
      value: inputViewModel.isFocused || inputViewModel.isSubmitted
    )
    .onAppear {
      bestSellerViewModel.send(.onAppear)
      recentSearchViewModel.send(.onAppear)
    }
    .onDisappear {
      resultViewModel.send(.cancelTask)
      recentSearchViewModel.send(.cancelTask)
      bestSellerViewModel.send(.cancelTask)
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
        text: $inputViewModel.searchText,
        isFocused: $inputViewModel.isFocused,
        onSubmit: {
          inputViewModel.send(.onSubmitSearch)
          
          if !inputViewModel.searchText.isEmpty {
            resultViewModel.send(.clearResult)
            recentSearchViewModel.send(.addKeyword(inputViewModel.searchText))
            resultViewModel.send(.searchAll(inputViewModel.searchText))
          }
        })
      
      if inputViewModel.searchText.isEmpty {
        SearchButton {
          coordinator.push(.barcode)
        }
      } else {
        SearchButton(style: .close) {
          inputViewModel.send(.onTapClear)
          resultViewModel.send(.clearResult)
        }
      }
    }
  }
  
  // MARK: - (S)bestSellerSection
  private var bestSellerSection: some View {
    VStack(alignment: .leading, spacing: layoutSize) {
      Text("인기 도서")
        .brStyleFont(.pretendard(.semiBold, size: 18),
                     lineHeight: 1,
                     letterSpacing: -0.025)
        .foregroundStyle(.black)
      
      BestSellerView(bookList: bestSellerViewModel.bestBookList) { book in
        coordinator.push(.searchBook(isbn: book.isbn))
      }
    } // : vstack - best seller
  }
}

//#Preview {
//  SearchView(viewModel: SearchViewModel())
//}



// MARK: - (S)SearchContentView
struct SearchContentView: View {
  @ObservedObject var inputViewModel: SearchInputViewModel
  @ObservedObject var recentSearchViewModel: RecentSearchViewModel
  @ObservedObject var resultViewModel: SearchResultViewModel
  @ObservedObject var bestSellerViewModel: BestSellerViewModel
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  var layoutSize: CGFloat
  var horizontalPadding: CGFloat
  
  var body: some View {
    Group {
      if inputViewModel.isFocused {
        RecentSearchView(
          viewModel: recentSearchViewModel,
          inputViewModel: inputViewModel,
          resultViewModel: resultViewModel
        )
        .padding(.horizontal, horizontalPadding)
        
      } else if inputViewModel.isSubmitted {
        SearchResultView(
          viewModel: resultViewModel
        )
        .onDisappear {
          resultViewModel.send(.cancelSelect)
        }
        
      } else {
        VStack(alignment: .leading, spacing: layoutSize) {
          Text("인기 도서")
            .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1, letterSpacing: -0.025)
            .foregroundStyle(.black)
          
          if bestSellerViewModel.bestBookList.isEmpty {
            LoadingView()
          } else {
            BestSellerView(bookList: bestSellerViewModel.bestBookList) { book in
              coordinator.push(.searchBook(isbn: book.isbn))
            }
          }
        }
        .padding(.horizontal, horizontalPadding)
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .transition(.opacity)
  }
}
