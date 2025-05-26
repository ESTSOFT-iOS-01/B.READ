//
//  RecordMemoViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation
// TODO: 순서대로 구현
// 1. 검색어 submit하면 검색
// 2. 검색어 하이라이트
// 3. 실시간 검색어 반영(combine?)

final class RecordMemoViewModel: ObservableObject {
  
  // MARK: - State
  struct RecordMemoViewState {
    var displayMemos: [[RecordMemoVO]] = [] // 책에 맞는 메모들
    var displaybooks: [String] = [] // 책 이름
    var searchText: String = ""
  }
  
  @Published var state: RecordMemoViewState = .init()
  
  
  // MARK: - Internal Variable
  private var memos: [String: [RecordMemoVO]] = [:] // key: ISBN, value: [MemoVO]
  private var books: [String: String] = [:] // key: ISBN, value: 책제목
  
  // MARK: - Dependency
//  @Dependency private var exampleUseCase: ExampleUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onSubmit
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadAllMemos()
      filterMemos()
//      print(state.displayMemos)
      for memo in state.displayMemos {
        print(memo)
      }
    case .onSubmit:
      print("검색어: \(state.searchText)")
    }
  }
}

private extension RecordMemoViewModel {
  
  func loadAllMemos() {
    // 방법 1. 메모를 전부 가져옴 -> 메모에 따른 책 정보를 가져옴
    // 1. Memo UseCase loadAllMemos
    // 2. MemoVO의 ISBN에 해당하는 책정보를 가져옴
    let fetchedMemos: [Memo] = DummyData.dummyMemos
    fetchedMemos.forEach {
      memos[$0.isbn, default: []].append(RecordMemoVO($0))
    }
    
    // TODO: - 원래는 isbn으로 책정보 바로 가져와야함
    for isbn in memos.keys {
      if let book = DummyData.dummyBooks.filter({ $0.isbn == isbn }).first {
        books[isbn] = book.name
      }
    }
  }
  
  func filterMemos() {
    for book in books {
      state.displaybooks.append(book.value)
      var displayMemo: [RecordMemoVO] = []
      if let memos = memos[book.key] {
        for memo in memos {
          displayMemo.append(memo)
        }
      }
      state.displayMemos.append(displayMemo)
    }
  }
}
