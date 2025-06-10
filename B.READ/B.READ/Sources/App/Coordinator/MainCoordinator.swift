//
//  MainCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

enum MainRoute: Hashable {
  
  // MARK: - Search
  case barcode
  case searchBook(isbn: String)
  case goToWebView(url: URL)
  
  // MARK: - Library
  case libraryDetail(id: String)
  case summaryDetail(record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO])
  
  // MARK: - Sentence
  case sentenceInput(mode: SentenceInputMode)
  case pageInput(record: RecordDetailVO, quote: QuoteVO)
  
  // MARK: - Memo
//  case memo(id: String? = nil, record: Record, totalPage: Int)
  case memo(id: String? = nil, record: RecordDetailVO)
  
  // MARK: - MyPage
  case insertNickname
  case selectCategory
}

enum SheetRoute: Identifiable {
  case createRecord(
    state: Binding<ReadingState>,
    book: Book,
    onComplete: (_ isEdit: Bool) -> Void
  )
  
  case updateRecord(
    state: Binding<ReadingState>,
    record: RecordDetailVO,
    onComplete: (_ isEdit: Bool) -> Void
  )
  
  var id: String {
    String(describing: self)
  }
}

extension Coordinator where R == SheetRoute {
  @ViewBuilder
  func buildView(for route: R) -> some View {
    switch route {
    case let .createRecord(state, book, onComplete):
      CreateRecordView(
        state: state,
        viewModel: NewRecordViewModel(book: book),
        onComplete: onComplete
      )
      
    case let .updateRecord(state, record, onComplete):
      CreateRecordView(
        state: state,
        viewModel: NewRecordViewModel(recordVO: record),
        onComplete: onComplete
      )
    }
  }
}

extension Coordinator where T == MainRoute {
  
  @ViewBuilder
  func buildView(for route: T) -> some View {
    switch route {
      
      // MARK: - Search Flow
    case .barcode:
      ScanView(viewModel: ScanViewModel())
    case .searchBook(let isbn):
      BookDetailView(viewModel: BookViewModel(isbn: isbn))
    case .goToWebView(let url):
      WebView(url: url)
        .navigationBarBackButtonHidden()
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              self.pop()
            } label: {
              Image(systemName: SFSymbol.xmark.name)
                .foregroundStyle(.green6)
            }
          }
        }
      
      // MARK: - Library
    case .libraryDetail(let id):
      RecordDetailView(viewModel: .init(recordID: id))
    case let .summaryDetail(record, memos, quotes):
      AlanSummaryView(viewModel: .init(record: record, memos: memos, quotes: quotes))
      
      // MARK: - Sentence
    case .sentenceInput(let mode):
      SentenceInputView(viewModel: .init(mode: mode))
    case .pageInput(let record, let quote):
      PageInputView(viewModel: .init(record: record, quote: quote))
    
      // MARK: - Memo
    case .memo(let id, let record):
      MemoView(viewModel: MemoViewModel(id: id, record: record), totalPage: record.totalPage)
      
      // MARK: - MyPage Flow
    case .insertNickname:
      NicknameView()
      
    case .selectCategory:
      CategorySelectionView()
    }
  }
}
