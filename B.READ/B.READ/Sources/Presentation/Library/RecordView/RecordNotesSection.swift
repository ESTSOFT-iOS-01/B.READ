//
//  RecordNotesSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordNotesSection
struct RecordNotesSection: View {
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  
  enum CellType {
    case memo
    case quote
    
    var name: String {
      switch self {
      case .memo: "메모"
      case .quote: "문장"
      }
    }
  }
  
  @ObservedObject var viewModel: RecordDetailViewModel
  @State var showMenuActionSheet: Bool = false
  private var cellType: CellType {
    if viewModel.state.selectedTab == 0 { return .memo }
    else { return .quote }
  }

  
  var body: some View {
    LazyVStack {
      if cellType == .memo {
        ForEach(viewModel.state.memos) { memo in
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
        ForEach(viewModel.state.quotes) { quote in
          QuoteCell(content: quote.content, page: quote.page, colorTone: .soft) {
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
        // TODO: 수정 버전 페이지로 넘어가기
        coordinator.push(.sentenceInput(isbn: viewModel.state.info?.record.isbn ?? ""))
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
  RecordDetailView(viewModel: .init(
    recordID: DummyData.dummyRecords[2].id,
    isbn: DummyData.dummyRecords[2].isbn
  ))
}
