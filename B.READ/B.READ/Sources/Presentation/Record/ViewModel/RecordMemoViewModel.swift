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

// MARK: - (C)RecordMemoViewModel
final class RecordMemoViewModel: ObservableObject {
  
  // MARK: - State
  struct RecordMemoViewState {
    var displayMemoGroups: [MemoGroup] = []
    var searchText: String = ""
  }
  
  @Published var state: RecordMemoViewState = .init()
  
  
  // MARK: - Internal Variable
  private var memoGroups: [MemoGroup] = []
  
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
        loadMemoGroups()
        sortDisplayMemoGroups()
    case .onSubmit:
      print("검색어: \(state.searchText)")
    }
  }
}

private extension RecordMemoViewModel {
  /// 메모를 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadMemoGroups() {
//    // TODO: - memoUseCase.fetchAllMemo()으로 변경
//    let allMemos = DummyData.dummyMemos
//    
//    let memoDict = Dictionary(grouping: allMemos, by: { $0.isbn })
//    memoGroups = memoDict.compactMap { isbn, memos in
//      
//      let memoVOs = memos.map { MemoVO($0) }
//      // TODO: - libraryUseCase.fetchBook(isbn)으로 변경
//      // let book = await libraryUsecase.fetchBook(isbn)
//      // return MemoGroup(isbn: isbn, bookTitle: book.name, memos: memoVOs)
//      if let book = DummyData.dummyBooks.filter({ $0.isbn == isbn }).first {
//        return MemoGroup(isbn: book.isbn, bookTitle: book.name, memos: memoVOs)
//      } else {
//        return nil
//      }
//    }
    
    // TODO: - 검색어 필터 들어가면 필터해주는 곳에서 처리해줌
    state.displayMemoGroups = memoGroups
  }
  
  // TODO: - 정렬 버트 만들고 기능 추가 예정
  /// 보여주고자 하는 Memo의 순서를 정렬합니다.
  func sortDisplayMemoGroups() {
    // 1. MemoGroup을 정렬
    // 2. MemoGroup에 담긴 Memos를 정렬
    state.displayMemoGroups = state.displayMemoGroups.sorted { $0.bookTitle < $1.bookTitle }
    
    for (index, memoGroup) in state.displayMemoGroups.enumerated() {
      state.displayMemoGroups[index].memos = memoGroup.memos.sorted { $0.pages.0 < $1.pages.0 }
    }
  }
}
