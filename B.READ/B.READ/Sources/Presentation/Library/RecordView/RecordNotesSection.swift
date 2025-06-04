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
          }
        } // : ForEach
      } else {
        ForEach($viewModel.quotes) { $quote in
          QuoteCell(
            content: quote.content,
            page: quote.page,
            colorTone: .soft
          ) {
            showMenuActionSheet = true
          }
        } // : ForEach
      }
    } // : LazyVStcks
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8)
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
        print("\(type.name) 수정 선택")
      case .quote:
        print("\(type.name) 수정 선택")
        // TODO: 문장넘겨주기
//        if let quote = viewModel.state.selectedQuote, let isbn = viewModel.state.info?.record.isbn {
//          coordinator.push(.sentenceInput(mode: .edit(isbn: isbn, quote: quote)))
//        } else {
//          print("선택된 문장이 없습니다.")
//        }
      }
    }
    
    Button("\(type.name) 삭제", role: .destructive) {
      switch type {
      case .memo:
        print("\(type.name) 삭제 선택")
      case .quote:
        print("\(type.name) 삭제 선택")
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
