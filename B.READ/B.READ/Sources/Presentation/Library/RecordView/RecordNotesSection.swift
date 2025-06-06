//
//  RecordNotesSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordNotesSection
struct RecordNotesSection: View {
  enum CellType: Int {
    case memo = 0
    case quote
    
    var name: String {
      switch self {
      case .memo: "메모"
      case .quote: "문장"
      }
    }
  }
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @ObservedObject var viewModel: RecordDetailViewModel
  @State var showMenuActionSheet: Bool = false

  private var cellType: CellType {
    return CellType(rawValue: viewModel.selectedTab) ?? .memo
  }
  
  
  var body: some View {
    LazyVStack(alignment: .trailing, spacing: 8) {
      // 리스트 뷰
      if cellType == .memo {
        ForEach($viewModel.memos) { $memo in
          MemoCell(
            content: memo.content,
            date: memo.createdAt,
            startPage: memo.pages.0,
            endPage: memo.pages.1
          ) {
            showMenuActionSheet = true
            viewModel.selectedMemo = memo
          }
        } // : ForEach
      } else {
        ForEach($viewModel.quotes) { $quote in
          QuoteCell(
            content: quote.content, 
            page: quote.page,
            colorTone: ColorTone.tone(isbn: quote.isbn)
          ) {
            showMenuActionSheet = true
            viewModel.selectedQuote = quote
          }
        } // : ForEach
      }
    } // : LazyVStcks
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8)
    .padding(.bottom, 72)
    .confirmationDialog(
      "메뉴를 선택하세요",
      isPresented: $showMenuActionSheet,
      titleVisibility: .hidden
    ) {
      menuActionSheet(type: cellType)
    }
  }
  
  @ViewBuilder
  private func menuActionSheet(type: CellType) -> some View {
    Button("\(type.name) 수정") {
      switch type {
      case .memo:
        guard let record = viewModel.record, let memo = viewModel.selectedMemo else { return }
        coordinator.push(.memo(id: memo.id, record: record))
      case .quote:
        guard let record = viewModel.record, let quote = viewModel.selectedQuote else { return }
        coordinator.push(.sentenceInput(mode: .edit(record: record, quote: quote)))
      }
    }
    
    // TODO: - [시르] 삭제 alert띄우기
    Button("\(type.name) 삭제", role: .destructive) {
      switch type {
      case .memo:
        guard let memo = viewModel.selectedMemo else { return }
        viewModel.send(.deleteMemo(id: memo.id))
      case .quote:
        guard let quote = viewModel.selectedQuote else { return }
        viewModel.send(.deleteQuote(id: quote.id))
      }
    }
    
    Button("취소", role: .cancel) { }
  }
}

#Preview {
  PreviewableContainer {
    RecordNotesSection(viewModel: .init(recordID: DummyData.dummyRecords[2].id))
  }
}
