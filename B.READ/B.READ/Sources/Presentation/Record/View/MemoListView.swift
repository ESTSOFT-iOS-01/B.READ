//
//  MemoListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import SwiftUI

// MARK: - (S)MemoListView
struct MemoListView: View {
  @EnvironmentObject private var coordinator: Coordinator<MainRoute, SheetRoute>
  @ObservedObject var viewModel: RecordMemoViewModel
  @State private var showMenuActionSheet = false
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 8) {
        
        ForEach($viewModel.displayMemoGroups) { $group in
          Section {
            ForEach($group.memos) { $memo in
              MemoCell(
                content: memo.content,
                date: memo.createdAt,
                startPage: memo.pages.0,
                endPage: memo.pages.1
              ) {
                showMenuActionSheet = true
                viewModel.selectedMemo = memo
              }
              .padding(.leading, 8)
            }

          } header: {
            Text(group.bookTitle)
              .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(.backgroundDefault)
              .padding(.top, 24)
          }// : Section
        }
        
      } // : LazyVStack
    } // : ScrollView
    .background(.backgroundDefault)
    .confirmationDialog(
      "메뉴를 선택하세요",
      isPresented: $showMenuActionSheet,
      titleVisibility: .hidden
    ) {
      menuActionSheet()
    }
  }
  
  // MARK: - (F)menuActionSheet
  @ViewBuilder
  private func menuActionSheet() -> some View {
    Button("메모 수정") {
//      guard let record = viewModel.record, let memo = viewModel.selectedMemo else { return }
//      coordinator.push(.memo(id: memo.id, record: record))
    }
    
    // TODO: - [시르] 삭제 alert띄우기
    Button("메모 삭제", role: .destructive) {
      guard let memo = viewModel.selectedMemo else { return }
      viewModel.send(.deleteMemo(id: memo.id))
    }
    
    Button("취소", role: .cancel) { }
  }
}

#Preview {
  RecordMemoView()
}
