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
  func isbn으로_책_상세_조회() async throws {
    // when
    let detail = try await searchUseCase.searchBookDetail(isbn: "9791187011590")
    
    // then
    #expect(detail.title == "데미안 (오리지널 초판본 표지디자인) - 최신 원전 완역본")
  }
  
}

