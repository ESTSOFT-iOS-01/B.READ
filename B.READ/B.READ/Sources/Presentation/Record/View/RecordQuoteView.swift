//
//  RecordQuoteView.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import SwiftUI

// MARK: - (S)RecordQuoteView
struct RecordQuoteView: View {
  @ObservedObject var viewModel = RecordQuoteViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Hear Quote")
//      HStack {
//        SearchBar(text: $viewModel.state.searchText, onSubmit: {
//          if !viewModel.state.searchText.isEmpty {
//            viewModel.send(.onSubmit)
//          }
//        }, style: .compact)
//        
//        sortButton()
//          .padding(.trailing, 4)
//      } // : HStack
//      
//      QuoteListView(quoteGroups: viewModel.state.displayQuoteGroups)
//      .padding(.top, 8)
//      .scrollIndicators(.never)
    } // : VStack
    .onAppear {
//      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  PreviewableContainer {
    RecordQuoteView()
      .padding(.horizontal, 24)
  }
}
