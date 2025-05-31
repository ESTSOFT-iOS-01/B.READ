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
  @Dependency private var quoteUseCase: QuoteUseCase
  @Dependency private var libraryUseCase: LibraryUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onSubmit
    case deleteQuote
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task { [weak self] in
        guard let self = self else { return }
        
        await self.loadQuoteGroups()
        await self.sortDisplayQuoteGroups()
      }
      
    case .onSubmit:
      print("검색어: \(state.searchText)")
      
    case .deleteQuote:
      print("문장 삭제")
    }
  }
}

private extension RecordQuoteViewModel {
  /// 문장을 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadQuoteGroups() async {
    
    // 1. 전체 문장을 가져옴
    guard let allQuotes = try? await quoteUseCase.fetchAllQuotes() else {
      print("RepositoryError.fetchError.errorDescription")
      return
    }
    
    // 2. 문장을 ISBN을 기준으로 나눔
    let quoteDict = Dictionary(grouping: allQuotes, by: { $0.isbn })
    
    let quoteGroups: [QuoteGroup] = await withTaskGroup(of: QuoteGroup?.self) {
      [weak self] group in
      guard let self = self else { return [] }
      
      // 3. 구분된 책의 문장을 QuoteGroup으로 생성
      for (isbn, quotes) in quoteDict {
        group.addTask {
          do {
            let bookTitle = try await self.quoteUseCase.loadBookTitle(isbn)
            let quoteVOs = quotes.map { QuoteVO($0) }
            return QuoteGroup(isbn: isbn, bookTitle: bookTitle, quotes: quoteVOs)
          } catch {
            print("ERROR: QuoteGroup Create Fail")
            return nil
          }
        }
      }
      
      var results: [QuoteGroup] = []
      
      for await result in group {
        if let item = result {
          results.append(item)
        }
      }
      
      return results
    } // : withTaskGroup
    
    // 4. 만들어진 QuoteGroup을 반영
    await MainActor.run {
      state.displayQuoteGroups = quoteGroups
    }
  }
  
  // TODO: - 정렬 버튼 만들고 기능 추가 예정
  /// 보여주고자 하는 Quote의 순서를 정렬합니다.
  func sortDisplayQuoteGroups(by: SortState = .older) async {
    // 1. 태스크 그룹으로 정렬
    let quoteGroups = await withTaskGroup(of: QuoteGroup.self) { group in
      
      // 2. 도서 제목 이름 순으로 정렬을 기준으로 작동
      let sortedGroup = state.displayQuoteGroups.sorted { $0.bookTitle > $1.bookTitle }
      
      // 3. 각 도서별 문장을 비동기로 정렬
      for groupItem in sortedGroup {
        group.addTask {
          // TODO: - 정렬 기준별 구현
          // 4. 우선 페이지 오름차순으로 정렬
          let sortedQuotes = groupItem.quotes.sorted { $0.page < $1.page }
          return QuoteGroup(
            isbn: groupItem.isbn,
            bookTitle: groupItem.bookTitle,
            quotes: sortedQuotes
          )
        }
      }
      
      var results: [QuoteGroup] = []
      // 5. 결과값 저장
      for await result in group {
        results.append(result)
      }
      
      return results
    }
    
    // 6. 뷰에 반영
    await MainActor.run {
      state.displayQuoteGroups = quoteGroups
    }
  }
}

// 공통 상태로 뺄지 각 뷰 마다 만들지는 고민
// MARK: - (E)SortState
enum SortState {
  case recent
  case older
}
