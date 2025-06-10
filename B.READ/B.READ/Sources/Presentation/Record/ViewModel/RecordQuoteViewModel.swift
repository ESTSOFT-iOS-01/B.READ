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
  @Published var highlightKeyword: String? = nil
  
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
      searchQuotes()
      
    case .deleteQuote(let id):
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
          // 5. 만들어진 QuoteGroup을 반영
          self.quoteGroups = quoteGroups
          // 6. 검색어 필터를 진행
          searchQuotes()
        }
      } catch {
        print("문장 로드 중 문제 발생")
      }
    }
  }
  
  /// 보여주고자 하는 Quote의 순서를 정렬합니다.
  func sortDisplayQuoteGroups() {
    let sortedGroup = self.displayQuoteGroups
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
  
  /// 검색어롤 문장을 필터링 합니다.
  func searchQuotes() {
    // 1. 검색어가 없으면 전체 문장을 보여줌(화이트스페이스, 줄바꿈 제거)
    let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      self.searchText = ""
      self.highlightKeyword = nil
      self.displayQuoteGroups = quoteGroups
      self.sortDisplayQuoteGroups()
      return
    }
    
    // 대소문자 구별하지 않음
    let keyword = searchText.lowercased()
    
    // 2. 문장에서 검색어가 포함된 것을 필터링
    let filteredGroups = quoteGroups.compactMap { group -> QuoteGroup? in
      // 2-1. 책 제목을 필터링
      let bookTitleMatched = group.bookTitle.lowercased().contains(keyword)
      
      // 2-2. 메모 내용을 필터링
      let matchedQuotes = group.quotes.filter {
        $0.content.lowercased().contains(keyword)
      }
      
      // 2-3. 책 제목에 포함되면 전부, 내용만 포함되면 필터된 내용만
      if bookTitleMatched || !matchedQuotes.isEmpty {
        return QuoteGroup(
          isbn: group.isbn,
          bookTitle: group.bookTitle,
          quotes: bookTitleMatched ? group.quotes : matchedQuotes
        )
      } else {
        return nil
      }
    }
    
    // 3. 필터한 내용을 저장
    self.displayQuoteGroups = filteredGroups
    
    // 4. 필터한 내용을 정렬
    self.sortDisplayQuoteGroups()
    
    // 5. 하이라이트 키워드 반영
    self.highlightKeyword = trimmed
  }
}
