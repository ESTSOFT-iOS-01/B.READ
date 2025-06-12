//
//  RecordMemoView.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import SwiftUI

// MARK: - (S)RecordMemoView
struct RecordMemoView: View {
  @ObservedObject var viewModel: RecordMemoViewModel
  @State private var showSortMenu: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        SearchBar(
          text: $viewModel.searchText,
          onSubmit: {
            if !viewModel.searchText.isEmpty {
              viewModel.send(.onSubmit)
            }
          },
          style: .compact)
        
        SortMenu(
          isOpened: $showSortMenu,
          selectedOption: $viewModel.selectedSort,
          type: .memo
        )
        .padding(.trailing, 4)
        .onChange(of: viewModel.selectedSort) {
          viewModel.send(.selectSort)
        }
      } // : HStack
      
      MemoListView(viewModel: viewModel)
        .padding(.top, 8)
        .scrollIndicators(.never)
    } // : VStack
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  @Previewable @StateObject var viewModel = RecordMemoViewModel()
  PreviewableContainer {
    RecordMemoView(viewModel: viewModel)
      .padding(.horizontal, 24)
  }
}
