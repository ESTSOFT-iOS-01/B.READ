//
//  RecordQuoteView.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import SwiftUI

// MARK: - (S)RecordQuoteView
struct RecordQuoteView: View {
  @ObservedObject var viewModel: RecordQuoteViewModel
  @State private var showSortMenu: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        SearchBar(
          text: $viewModel.searchText,
          onSubmit: { viewModel.send(.onSubmit) },
          style: .compact
        )
        
        SortMenu(
          isOpened: $showSortMenu,
          selectedOption: $viewModel.selectedSort,
          type: .quote
        )
        .padding(.trailing, 4)
        .onChange(of: viewModel.selectedSort) {
          viewModel.send(.selectSort)
        }
      } // : HStack
      
      if viewModel.quoteGroups.isEmpty {
        FailedView(
          title: "😢 문장을 작성하러 가볼까요?",
          desp: "작성하신 문장이 없습니다."
        )
      } else if !viewModel.searchText.isEmpty && viewModel.displayQuoteGroups.isEmpty {
        FailedView(desp: "\"\(viewModel.searchText)\"에 일치하는 검색 결과가 없습니다.")
      } else {
        QuoteListView(viewModel: viewModel)
          .padding(.top, 8)
          .scrollIndicators(.never)
      }
    } // : VStack
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  @Previewable @StateObject var viewModel = RecordQuoteViewModel()
  PreviewableContainer {
    RecordQuoteView(viewModel: viewModel)
      .padding(.horizontal, 24)
  }
}
