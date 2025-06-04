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
  
  // MARK: - Sentence
  case sentenceInput(mode: SentenceInputMode)
  case pageInput(mode: SentenceInputMode, sentence: String)
  
  // MARK: - Memo
  case memo(id: String? = nil, record: Record, totalPage: Int)
  
  // MARK: - MyPage
  case insertNickname
  case selectCategory
}

enum SheetRoute: Identifiable {
  case createRecord(state: Binding<ReadingState>, page: Int)
  
  var id: String {
    String(describing: self)
  }
}

extension Coordinator where R == SheetRoute {
  @ViewBuilder
  func buildView(for route: R) -> some View {
    switch route {
    case let .createRecord(state, page):
      CreateRecordView(state: state, viewModel: NewRecordViewModel(maxPage: page))
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
      
      // MARK: - Sentence
    case .sentenceInput(let mode):
        SentenceInputView(mode: mode)

    case .pageInput(let mode, let sentence):
        PageInputView(mode: mode, sentence: sentence)
    
      // MARK: - Memo
    case .memo(let id, let record, let page):
      MemoView(viewModel: MemoViewModel(id: id, record: record), totalPage: page)
      
      // MARK: - MyPage Flow
    case .insertNickname:
      NicknameView()
      
    case .selectCategory:
      CategorySelectionView()
    }
  }
}
