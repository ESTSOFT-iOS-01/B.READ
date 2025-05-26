//
//  RecordMemoView.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import SwiftUI

struct RecordMemoView: View {
  @StateObject var viewModel = RecordMemoViewModel()
  
  var body: some View {
    VStack {
      SearchBar(text: $viewModel.state.searchText) {
        if !viewModel.state.searchText.isEmpty {
          viewModel.send(.onSubmit)
        }
      }
    }
//    SearchBar(
//      text: $viewModel.state.searchText,
//      isFocused: $viewModel.state.isSearchFocused,
//      onSubmit: {
//        if !viewModel.state.searchText.isEmpty {
//          viewModel.send(.onSubmitSearch)
//        }
//      })
  }
}

#Preview {
  RecordMemoView()
}
