//
//  RecordQuoteViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import Foundation
// TODO: 순서대로 구현
// 1. 검색어 submit하면 검색
// 2. 검색어 하이라이트
// 3. 실시간 검색어 반영(combine?)

final class RecordQuoteViewModel: ObservableObject {
  
  // MARK: - State
  struct RecordQuoteViewState {
    var displayQuoteGroups: [QuoteGroup] = []
    var searchText: String = ""
  }
  
  @Published var state: RecordQuoteViewState = .init()
  
  
  // MARK: - Internal Variable
  private var quoteGroups: [QuoteGroup] = []
  
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
      loadQuoteGroups()
      sortDisplayQuoteGroups()
    case .onSubmit:
      print("검색어: \(state.searchText)")
    }
  }
}

private extension RecordQuoteViewModel {
  /// 문장을 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadQuoteGroups() {
    // TODO: - quoteUseCase.fetchAllQuote()으로 변경
    let allQuotes = DummyData.dummyQuote
    
    let quoteDict = Dictionary(grouping: allQuotes, by: { $0.isbn })
    quoteGroups = quoteDict.compactMap { isbn, quotes in
      
      let quoteVOs = quotes.map { QuoteVO($0) }
      // TODO: - libraryUseCase.fetchBook(isbn)으로 변경
      // let book = await libraryUsecase.fetchBook(isbn)
      // return QuoteGroup(isbn: isbn, bookTitle: book.name, quotes: quoteVOs)
      if let book = DummyData.dummyBooks.filter({ $0.isbn == isbn }).first {
        return QuoteGroup(isbn: book.isbn, bookTitle: book.name, quotes: quoteVOs)
      } else {
        return nil
      }
    }
    
    // TODO: - 검색어 필터 들어가면 필터해주는 곳에서 처리해줌
    state.displayQuoteGroups = quoteGroups
  }
  
  // TODO: - 정렬 버트 만들고 기능 추가 예정
  /// 보여주고자 하는 Quote의 순서를 정렬합니다.
  func sortDisplayQuoteGroups() {
    // 1. QuoteGroup을 정렬 - 우선 제목 순
    // 2. QuoteGroup에 담긴 Quotes를 정렬
    
    state.displayQuoteGroups = state.displayQuoteGroups.sorted { $0.bookTitle < $1.bookTitle }
    
    for (index, quoteGroup) in state.displayQuoteGroups.enumerated() {
      state.displayQuoteGroups[index].quotes = quoteGroup.quotes.sorted { $0.page < $1.page }
    }
  }
}
