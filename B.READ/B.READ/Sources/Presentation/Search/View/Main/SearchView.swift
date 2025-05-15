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
  
  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      Text("로고")
        .frame(width: 200 ,height: 44)
      
      HStack(spacing: 16) {
        SearchBar(text: $viewModel.state.searchText,
                  isFocused: $isSearchFocused)
        SearchButton(icon: SearchConstants.Icon.barcord) {
          viewModel.send(.onTapBarcode)
        }
      } // : Hstack - 검색창 영역
      
      VStack(alignment: .leading, spacing: 16) {
        Text("인기 도서")
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1, letterSpacing: -0.025)
          .foregroundStyle(.black)
        BestSellerView(bookList: viewModel.state.bookList) { rank, name in
          viewModel.send(.onTapBestSeller(rank: rank, name: name))
        }
      } // : vstack - best seller
    } // : vStack
    .padding(.horizontal, 24)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  SearchView(viewModel: SearchViewModel())
}
