
//
//  QuoteUseCaseTest.swift
//  B.READTests
//
//  Created by 도민준 on 5/22/25.
//

import Foundation
import Testing

struct QuoteUseCaseTest {
  private let quoteRepository: QuoteRepository
  private let bookRepository: BookRepository
  private let useCase: QuoteUseCase
  
  init() {
    self.quoteRepository = QuoteRepositoryStub()
    self.bookRepository  = BookRepositoryStub()
    self.useCase = QuoteUseCaseImpl(quoteRepository: quoteRepository, bookRepository: bookRepository)
  }
  
  @Test("문장 추가 성공 테스트")
  func 문장_추가_성공() async throws {
    // given: 테스트용 도서 등록
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    
    // when
    try await useCase.addQuote(DummyData.quote)
    
    // then
    let stored = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    #expect(stored == DummyData.quote)
  }
  
  @Test("문장 추가 빈 내용 오류 테스트")
  func 문장_추가_빈내용_오류() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    var q = DummyData.quote
    q.content = "   "
    
    // when-then
    await #expect(throws: QuoteUseCaseError.emptyContent, performing: {
      try await useCase.addQuote(q)
    })
  }
  
  @Test("문장 추가 페이지 범위 초과 오류 테스트")
  func 문장_추가_페이지범위초과_오류() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    var q = DummyData.quote
    let max = DummyData.books.first { $0.isbn == q.isbn }!.totalPages
    q.page = max + 1
    
    // when-then
    await #expect(throws: QuoteUseCaseError.invalidPage(max: max), performing: {
      try await useCase.addQuote(q)
    })
  }
  
  @Test("문장 수정 성공 테스트")
  func 문장_수정_성공() async throws {
    // given: 도서 및 문장 등록
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    try await quoteRepository.createQuote(DummyData.quote)
    
    var updated = DummyData.quote
    updated.page    = 5
    updated.content = "업데이트"
    
    // when
    try await useCase.updateQuote(updated)
    
    // then
    let fetched = try await quoteRepository.fetchQuote(id: updated.id)
    #expect(fetched == updated)
  }
  
  @Test("문장 수정 빈 내용 오류 테스트")
  func 문장_수정_빈내용_오류() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    var updated = DummyData.quote
    updated.content = ""
    
    // when-then
    await #expect(throws: QuoteUseCaseError.emptyContent, performing: {
      try await useCase.updateQuote(updated)
    })
  }
  
  @Test("문장 삭제 성공 테스트")
  func 문장_삭제_성공() async throws {
    // given
    try await quoteRepository.createQuote(DummyData.quote)
    
    // when
    try await useCase.removeQuote(id: DummyData.quote.id)
    
    // then
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    })
  }
  
  @Test("단일 문장 조회 테스트")
  func 단일_문장_조회() async throws {
    // given
    try await quoteRepository.createQuote(DummyData.quote)
    
    // when
    let fetched = try await useCase.fetchQuote(id: DummyData.quote.id)
    
    // then
    #expect(fetched == DummyData.quote)
  }
  
  @Test("ISBN별 문장 조회 테스트")
  func ISBN별_문장_조회() async throws {
    // given
    let other = Quote(
      id: "id-2",
      isbn: DummyData.quote.isbn,
      content: "다른 문장",
      page: 1
    )
    try await quoteRepository.createQuote(DummyData.quote)
    try await quoteRepository.createQuote(other)
    
    // when
    let list = try await useCase.fetchQuotes(isbn: DummyData.quote.isbn)
    
    // then
    #expect(list == [DummyData.quote, other])
  }
  
  @Test("전체 문장 조회 테스트")
  func 전체_문장_조회() async throws {
    // given
    let another = Quote(
      id: "id-3",
      isbn: "X",
      content: "X",
      page: 1
    )
    try await quoteRepository.createQuote(DummyData.quote)
    try await quoteRepository.createQuote(another)
    
    // when
    let all = try await useCase.fetchAllQuotes()
    
    // then
    #expect(all.count == 2)
  }
  
  @Test("페이지 유효 범위 테스트")
  func 페이지_유효_범위_테스트() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    
    // when
    try await useCase.validatePage(5, forISBN: DummyData.quote.isbn)
  }
  
  @Test("페이지 범위 초과 오류 테스트")
  func 페이지_범위_초과_오류() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    let max = DummyData.books.first { $0.isbn == DummyData.quote.isbn }!.totalPages
    
    // when-then
    await #expect(throws: QuoteUseCaseError.invalidPage(max: max), performing: {
      try await useCase.validatePage(max + 1, forISBN: DummyData.quote.isbn)
    })
  }
}
