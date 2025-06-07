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
  @State private var showDeleteAlert = false
  
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
              .padding(.top, 16)
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
    } // : confirmationDialog
    .alert("메모 삭제", isPresented: $showDeleteAlert) {
      Button("삭제", role: .destructive) {
        guard let memo = viewModel.selectedMemo else { return }
        viewModel.send(.deleteMemo(id: memo.id))
      }
      Button("취소", role: .cancel) { }
    } message: {
      Text("정말로 메모를 삭제하시겠습니까?")
    } // : alert
  }
  
  // TODO: - [시르]액션 시트 tintColor systemblue 적용하기
  // MARK: - (F)menuActionSheet
  @ViewBuilder
  private func menuActionSheet() -> some View {
    Button("메모 수정") {
      // TODO: - 메모 수정으로 넘어가게 해야함
//      guard let record = viewModel.record, let memo = viewModel.selectedMemo else { return }
//      coordinator.push(.memo(id: memo.id, record: record))
    }
    
    Button("메모 삭제", role: .destructive) {
      showDeleteAlert = true
    }
    
    Button("취소", role: .cancel) { }
  }
}

#Preview {
  @Previewable @StateObject var viewModel = RecordMemoViewModel()
  PreviewableContainer {
    MemoListView(viewModel: viewModel)
  }
}
