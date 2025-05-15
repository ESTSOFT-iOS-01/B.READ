//
//  SearchView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct SearchView: View {
  @ObservedObject var viewModel: SearchViewModel
  
  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      Text("로고")
        .frame(width: 200 ,height: 44)
      
      HStack(spacing: 16) {
        SearchBar(text: $viewModel.state.searchText)
        SearchButton(icon: SearchConstants.Icon.barcord) {
          viewModel.send(.onTapBarcode)
        }
      } // : Hstack
      
      VStack(alignment: .leading, spacing: 16) {
        Text("인기 도서")
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1, letterSpacing: -0.025)
          .foregroundStyle(.black)
        BestSellerView(bookList: viewModel.state.bookList) { rank, name in
          viewModel.send(.onTapBestSeller(rank: rank, name: name))
        }
      }
    }
    .padding(.horizontal, 24)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  SearchView(viewModel: SearchViewModel())
}
