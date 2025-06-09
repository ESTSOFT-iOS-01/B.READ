//
//  RecordNoteView.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import SwiftUI

// MARK: - (S)RecordNoteView
struct RecordNoteView: View {
  @ObservedObject var viewModel: RecordNoteViewModel
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
          type: .note
        )
        .padding(.trailing, 4)
        .onChange(of: viewModel.selectedSort) {
          viewModel.send(.selectSort)
        }
      } // : HStack
      
      NoteListview(viewModel: viewModel)
        .padding(.top, 8)
        .scrollIndicators(.never)
    } // : VStack
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  @Previewable @StateObject var viewModel = RecordNoteViewModel()
  PreviewableContainer {
    RecordNoteView(viewModel: viewModel)
  }
}
