//
//  RecordNotesSection.swift
//  B.READ
//
//  Created by 심근웅 on 5/23/25.
//

import SwiftUI

// MARK: - (S)RecordNotesSection
struct RecordNotesSection: View {
  
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
      switch cellType {
      case .memo:
        memoCells()
      case .quote:
        quoteCells()
      }
    } // : LazyVStcks
    .confirmationDialog(
      "메뉴를 선택하세요",
      isPresented: $showMenuActionSheet,
      titleVisibility: .hidden
    ) {
      menuActionSheet(type: cellType)
    }
  }
  
  // TODO: - memoCells랑 quoteCell를 하나로 합쳐보겠습니다.(2)
  // MARK: - (F)memoCells
  @ViewBuilder
  private func memoCells() -> some View {
    ForEach(viewModel.state.memos) { memo in
      MemoCell(
        content: memo.content,
        date: memo.createdAt,
        startPage: memo.pages.0,
        endPage: memo.pages.1
      ) {
        print("메모 메뉴 버튼 터치")
        showMenuActionSheet = true
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 8)
    } // : ForEach
  }
  
  // MARK: - (F)quoteCells
  @ViewBuilder
  private func quoteCells() -> some View {
    ForEach(viewModel.state.quotes) { quote in
      QuoteCell(
        content: quote.content,
        page: quote.page,
        colorTone: .soft
      ) {
        print("문장 메뉴 버튼 터치")
        showMenuActionSheet = true
      }
    } // : ForEach
  }
  
  @ViewBuilder
  private func menuActionSheet(type: CellType) -> some View {
    Button("\(type.name) 수정") {
      switch type {
      case .memo:
        print("\(type.name) 수정 선택")
      case .quote:
        print("\(type.name) 수정 선택")
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
