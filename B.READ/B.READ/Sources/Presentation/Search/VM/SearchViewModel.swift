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
    case onTapBarcode
    case onTapClear
    case onTapBestSeller(rank: Int, name: String)
    case onSubmitSearch
    case onTapTab(Int)
    case onTapBook(String)
    case onTapRecord(String)
    case deleteKeyword(at: Int)
    case deleteAllKeywords
    case selectKeyword(String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadDummyData()
      
    case .onTapBarcode:
      print("바코드 인식 화면으로 전환")
      
    case let .onTapBestSeller(rank, name):
      print("\(rank)위 '\(name)' 클릭됨!")
      state.searchText = name
      state.isSearchSubmitted = true
      appendKeyword(name)
      
    case .onTapClear:
      state.searchText = ""
      state.isSearchSubmitted = false
      
    case .onSubmitSearch:
      if !state.searchText.isEmpty {
        state.isSearchSubmitted = true
        appendKeyword(state.searchText)
        // TODO: 검색 결과 API 호출 후 bookResults / recordResults 채우기
        print("🔍 검색어 제출됨: \(state.searchText)")
      }
    case .onTapTab(let index):
      state.selectedTabIndex = index
      
    case .onTapBook(let isbn):
      print("도서 \(isbn) 선택됨")
      
    case .onTapRecord(let id):
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
    state.bestBookList = [
      "데미안",
      "미씽",
      "싯다르타",
      "하이데거의 사건 존재론",
      "이것이 취업을 위한 코딩테스트다 with Python",
      "풀스택 서버리스",
      "2022 제 16회 젊은작가상 수상작품집",
      "2023 제 16회 젊은작가상 수상작품집",
      "2025 제 16회 젊은작가상 수상작품집",
      "Essentail Grammar in Use with answers and eBook"
    ]
    state.keywordList = ["데미안", "코딩테스트", "미씽"]
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

struct SearchViewState {
  var searchText: String = ""
  var bestBookList: [String] = []
  var keywordList: [String] = []
  var bookResults: [BookVO] = []
  var recordResults: [RecordVO] = []
  var selectedTabIndex: Int = 0
  var isSearchSubmitted: Bool = false
}
