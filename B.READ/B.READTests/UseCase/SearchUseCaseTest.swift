//
//  SearchUseCaseTest.swift
//  B.READ
//
//  Created by 김도연 on 5/30/25.
//

import Foundation
import Testing

struct SearchUseCaseTest {
  private let searchUseCase: SearchUseCase
  private let recordRepository: RecordRepository
  private let bookRepository: BookRepository
  private let bookService: BookService
  
  init() {
    let storage = SwiftDataTestStorage()
    
    bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    bookService = AladinService()

    searchUseCase = SearchUseCaseImpl(
      bookRepository: bookRepository,
      recordRepository: recordRepository,
      bookService: bookService
    )
  }
  
  @Test("ISBN으로 책 상세 조회 성공")
  func searchBookByISBN() async throws {
    // given
    let title = "데미안 (오리지널 초판본 표지디자인) - 최신 원전 완역본"
    
    // when
    let detail = try await searchUseCase.searchBookDetail(isbn: "9791187011590")
    
    // then
    #expect(detail.title == title)
  }
  
  @Test("레포에서 키워드로 기록 조회 성공")
  func searchRecordByKeywordSuccess() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    
    for record in DummyData.records {
      try await recordRepository.createRecord(record)
    }
    
    // when
    let results = try await searchUseCase.searchBooksFromRepository(query: "타이탄")
    
    // then
    #expect(results.count == 1)
    #expect(results.first?.1.name == "타이탄의 도구들")
    #expect(results.first?.0.isbn == "9791158510619")
  }
  
  
  @Test("쿼리에 해당하는 책이 없을 때 검색 결과는 빈 배열이어야 한다")
  func searchRecordByKeywordEmptyResults() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    
    for record in DummyData.records {
      try await recordRepository.createRecord(record)
    }

    // when
    let results = try await searchUseCase.searchBooksFromRepository(query: "존재하지않는책")

    // then
    #expect(results.isEmpty)
  }

}

