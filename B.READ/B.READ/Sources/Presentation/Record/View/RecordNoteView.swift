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
      
      if viewModel.notes.isEmpty {
        FailedView(
          title: "😢 완독 후, 다시 빵식이를 불러주세요.",
          desp: "요약을 진행한 독서 기록이 업습니다."
        )
      } else if !viewModel.searchText.isEmpty && viewModel.displayNotes.isEmpty {
        FailedView(desp: "\"\(viewModel.searchText)\"에 일치하는 검색 결과가 없습니다.")
      } else {
        NoteListview(viewModel: viewModel)
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
  @Previewable @StateObject var viewModel = RecordNoteViewModel()
  PreviewableContainer {
    RecordNoteView(viewModel: viewModel)
  }
}
