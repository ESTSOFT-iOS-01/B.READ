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
    var recordResults: [RecordCellVO] = []
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
      BestSellerVO(
        id: UUID().uuidString,
        rank: $0,
        isbn: "1234567890\($0)",
        title: "베스트셀러 \($0)",
        author: "작가 \($0)",
        imageURL: "https://image.aladin.co.kr/product/36101/66/coversum/893643974x_2.jpg"
      )
    }

    state.keywordList = ["데미안", "코딩테스트", "미씽"]
    
    state.bookResults = (1...10).map {
      BookVO(
        id: UUID().uuidString,
        isbn: "1234567890\($0)",
        coverImage: Image(.exampleBook),
        title: "데미안 \($0)",
        author: "헤르만 헤세",
        publisher: "민음사",
        publishedDate: Date()
      )
    }
//    let notStartdata = RecordCellVO(
//      id: DummyData.dummyRecords[0].id,
//      isbn: DummyData.dummyRecords[0].isbn,
//      title: DummyData.dummyBooks[0].name,
//      coverImage: Image(.exampleBook),
//      readingState: ReadingState.fromEntity(DummyData.dummyRecords[0].state),
//      heart: DummyData.dummyRecords[0].heartCount,
//      progress: 0,
//      star: DummyData.dummyRecords[0].starCount,
//      memoCount: DummyData.dummyRecords[0].memoIDs.count,
//      quoteCount: DummyData.dummyRecords[0].quoteIDs.count,
//      period: DummyData.dummyRecords[0].period,
//      isFavorite: DummyData.dummyRecords[0].isFavorite,
//      createdAt: DummyData.dummyRecords[0].createdAt
//    )
//    let readingdata = RecordCellVO(
//      id: DummyData.dummyRecords[1].id,
//      isbn: DummyData.dummyRecords[1].isbn,
//      title: DummyData.dummyBooks[1].name,
//      coverImage: Image(.exampleBook),
//      readingState: ReadingState.fromEntity(DummyData.dummyRecords[1].state),
//      heart: DummyData.dummyRecords[1].heartCount,
//      progress: 65,
//      star: DummyData.dummyRecords[1].starCount,
//      memoCount: DummyData.dummyRecords[1].memoIDs.count,
//      quoteCount: DummyData.dummyRecords[1].quoteIDs.count,
//      period: DummyData.dummyRecords[1].period,
//      isFavorite: DummyData.dummyRecords[1].isFavorite,
//      createdAt: DummyData.dummyRecords[1].createdAt
//    )
//    let finisheddata = RecordCellVO(
//      id: DummyData.dummyRecords[2].id,
//      isbn: DummyData.dummyRecords[2].isbn,
//      title: DummyData.dummyBooks[2].name,
//      coverImage: Image(.exampleBook),
//      readingState: ReadingState.fromEntity(DummyData.dummyRecords[2].state),
//      heart: DummyData.dummyRecords[2].heartCount,
//      progress: 65,
//      star: DummyData.dummyRecords[2].starCount,
//      memoCount: DummyData.dummyRecords[2].memoIDs.count,
//      quoteCount: DummyData.dummyRecords[2].quoteIDs.count,
//      period: DummyData.dummyRecords[2].period,
//      isFavorite: DummyData.dummyRecords[2].isFavorite,
//      createdAt: DummyData.dummyRecords[2].createdAt
//    )
//    state.recordResults = [notStartdata, readingdata, finisheddata]
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
