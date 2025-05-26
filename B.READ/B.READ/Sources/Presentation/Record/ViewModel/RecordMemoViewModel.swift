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
    var memos: [String: [Data]] = [:] // key: ISBN, value: [MemoVO]
    var books: [String: String] = [:] // key: ISBN, value: 책제목
    var searchText: String = ""
  }
  
  @Published var state: RecordMemoViewState = .init()
  
  
  // MARK: - Internal Variable
  private var example: String?
  
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
//      reset()
      return
    case .onSubmit:
      print("검색어: \(state.searchText)")
    }
  }
}
