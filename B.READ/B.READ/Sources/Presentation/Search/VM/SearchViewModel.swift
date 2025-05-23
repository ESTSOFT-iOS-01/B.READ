//
//  SearchViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
  // MARK: - State
  struct SearchViewState {
    var searchText: String = ""
    var bestBookList: [BestSellerVO] = []
    var keywordList: [String] = []
    var bookResults: [BookVO] = []
    var recordResults: [RecordVO] = []
    var selectedTabIndex: Int = 0
    var isSearchSubmitted: Bool = false
    var isSearchFocused: Bool = false
  }
  
  @Published var state: SearchViewState = .init(
    searchText: "",
    bestBookList: [],
    keywordList: []
  )
  
  // MARK: - Dependency
  // 예시: 실제 구현에서는 UseCase 주입
  // @Dependency private var searchUseCase: SearchUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onTapClear
    case onSubmitSearch
    case onTapTab(Int)
    case onTapRecord(String)
    case deleteKeyword(at: Int)
    case deleteAllKeywords
    case selectKeyword(String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadDummyData()
      
    case .onTapClear:
      state.searchText = ""
      state.isSearchSubmitted = false
      state.isSearchFocused = true
      
    case .onSubmitSearch:
      if !state.searchText.isEmpty {
        state.isSearchSubmitted = true
        state.isSearchFocused = false
        
        appendKeyword(state.searchText)
        // TODO: 검색 결과 API 호출 후 bookResults / recordResults 채우기
      }
    case let .onTapTab(index):
      state.selectedTabIndex = index
      
    case let .onTapRecord(id):
      print("기록 \(id) 선택됨")
      
    case let .deleteKeyword(index):
      guard state.keywordList.indices.contains(index) else { return }
      state.keywordList.remove(at: index)
      
    case .deleteAllKeywords:
      state.keywordList.removeAll()
      
    case let .selectKeyword(keyword):
      state.searchText = keyword
      send(.onSubmitSearch)
    }
  }
}

// MARK: - Internal Function : DUMMY DATA SETTING
private extension SearchViewModel {
  func loadDummyData() {
    state.bestBookList = (1...10).map {
      BestSellerVO(isbn: "1234567890\($0)", title: "베스트셀러 \($0)")
    }
    
    state.keywordList = ["데미안", "코딩테스트", "미씽"]
    
    state.bookResults = (1...10).map {
      BookVO(
        isbn: "1234567890\($0)",
        coverImage: Image(.exampleBook),
        title: "데미안 \($0)",
        author: "헤르만 헤세",
        publisher: "민음사",
        publishedDate: Date()
      )
    }
    
    state.recordResults = [
      RecordVO(isbn: "123", coverImage: Image(.exampleBook), id: "1", title: "데미안", state: .notStart),
      RecordVO(isbn: "124", coverImage: Image(.exampleBook), id: "2", title: "데미안", state: .reading, startDate: Date()),
      RecordVO(isbn: "125", coverImage: Image(.exampleBook), id: "3", title: "데미안", state: .finished, startDate: Date(), endDate: Date())
    ]
  }
  
  func appendKeyword(_ keyword: String) {
    guard !keyword.isEmpty else { return }
    if state.keywordList.contains(keyword) {
      state.keywordList.removeAll { $0 == keyword }
    }
    state.keywordList.insert(keyword, at: 0)
    
    // 최대 5개까지만 유지
    if state.keywordList.count > 5 {
      state.keywordList = Array(state.keywordList.prefix(5))
    }
  }
}
