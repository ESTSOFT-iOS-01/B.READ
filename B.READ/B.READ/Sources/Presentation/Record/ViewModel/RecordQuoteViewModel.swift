//
//  RecordQuoteViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import Foundation

// MARK: - (C)RecordQuoteViewModel
final class RecordQuoteViewModel: ObservableObject {
  
  // MARK: - State
  @Published var displayQuoteGroups: [QuoteGroup] = []
  @Published var searchText: String = ""
  @Published var selectedSort: SortOption = .pageAscending
  
  // MARK: - Internal Variable
  private var quoteGroups: [QuoteGroup] = []
  var selectedQuote: QuoteVO? = nil
  
  // MARK: - Dependency
  @Dependency private var quoteUseCase: QuoteUseCase
  @Dependency private var libraryUseCase: LibraryUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case selectSort
    case onSubmit
    case deleteQuote(id: String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadQuoteGroups()
      
    case .selectSort:
      sortDisplayQuoteGroups()
      
    case .onSubmit:
      print("검색어: \(searchText)")
      
    case .deleteQuote(let id):
      print("문장 삭제")
      deleteQuote(id: id)
      
    }
  }
}

private extension RecordQuoteViewModel {
  /// 문장을 불러와서 뷰에 보여줄 형태로 가공합니다.
  func loadQuoteGroups() {
    Task {
      do {
        // 1. 전체 독서 기록을 받아옴
        let allRecords = try await libraryUseCase.loadRecordList()
        
        // 2. 모든 문장을 VO로 변환
        let allQuotes: [QuoteVO] = allRecords.flatMap { record, book in
          record.quotes.map { QuoteVO($0, record: RecordDetailVO(record: record, book: book)) }
        }
        
        // 3. ISBN 기준으로 문장을 그룹화
        let quoteDict = Dictionary(grouping: allQuotes, by: { $0.isbn })
        
        // 4. TaskGroup을 사용해 각 그룹을 QuoteGroup으로 변환
        let quoteGroups: [QuoteGroup] = await withTaskGroup(of: QuoteGroup?.self) {
          [weak self] group in
          guard let self = self else { return [] }
          
          // 3. 구분된 책의 문장을 QuoteGroup으로 생성
          for (isbn, quotes) in quoteDict {
            group.addTask {
              do {
                let bookTitle = try await self.quoteUseCase.loadBookTitle(isbn)
                return QuoteGroup(isbn: isbn, bookTitle: bookTitle, quotes: quotes)
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
        
        
        await MainActor.run {
          // 4. 만들어진 QuoteGroup을 반영
          self.quoteGroups = quoteGroups
          // 5. QuoteGroup 정렬을 진행
          sortDisplayQuoteGroups()
        }
      } catch {
        print("문장 로드 중 문제 발생")
      }
    }
  }
  
  /// 보여주고자 하는 Quote의 순서를 정렬합니다.
  func sortDisplayQuoteGroups() {
    let sortedGroup = quoteGroups
    // 1. 그룹 내부의 메모를 정렬
      .map { group in
        var sortedGroup = group
        sortedGroup.quotes = sortedGroup.quotes.sorted(by: self.selectedSort.sort)
        return sortedGroup
      }
    // 2. 그룹을 이름 순으로 정렬
      .sorted(by: self.selectedSort.sort)
    
    self.displayQuoteGroups = sortedGroup
  }
  
  /// 선택된 메모를 삭제 합니다.
  func deleteQuote(id: String) {
    Task {
      // 1. 데이터 삭제
      try await quoteUseCase.removeQuote(id: id)
      
      // 2. 데이터 일관성을 위해서 새로 데이터를 받아옴
      loadQuoteGroups()
    }
  }
}
