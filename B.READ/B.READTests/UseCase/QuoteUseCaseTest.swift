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
    self.useCase = QuoteUseCaseImpl(
      quoteRepository: quoteRepository,
      bookRepository: bookRepository
    )
  }
  
  @Test("Add Quote Success Test")
  func addQuoteSuccess() async throws {
    // given: register test books
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    
    // when
    try await useCase.addQuote(DummyData.quote)
    
    // then
    let stored = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    #expect(stored == DummyData.quote)
  }
  
  @Test("Add Quote Empty Content Error Test")
  func addQuoteEmptyContentError() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    var q = DummyData.quote
    q.content = "   "
    
    // when / then
    await #expect(throws: QuoteUseCaseError.emptyContent, performing: {
      try await useCase.addQuote(q)
    })
  }
  
  @Test("Add Quote Invalid Page Error Test")
  func addQuoteInvalidPageError() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    var q = DummyData.quote
    let max = DummyData.books
      .first { $0.isbn == q.isbn }!
      .totalPages
    q.page = max + 1
    
    // when / then
    await #expect(throws: QuoteUseCaseError.invalidPage(max: max), performing: {
      try await useCase.addQuote(q)
    })
  }
  
  @Test("Update Quote Success Test")
  func updateQuoteSuccess() async throws {
    // given: register book and quote
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    try await quoteRepository.createQuote(DummyData.quote)
    
    var updated = DummyData.quote
    updated.page = 5
    updated.content = "Updated"
    
    // when
    try await useCase.updateQuote(updated)
    
    // then
    let fetched = try await quoteRepository.fetchQuote(id: updated.id)
    #expect(fetched == updated)
  }
  
  @Test("Update Quote Empty Content Error Test")
  func updateQuoteEmptyContentError() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    var updated = DummyData.quote
    updated.content = ""
    
    // when / then
    await #expect(throws: QuoteUseCaseError.emptyContent, performing: {
      try await useCase.updateQuote(updated)
    })
  }
  
  @Test("Remove Quote Success Test")
  func removeQuoteSuccess() async throws {
    // given
    try await quoteRepository.createQuote(DummyData.quote)
    
    // when
    try await useCase.removeQuote(id: DummyData.quote.id)
    
    // then
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    })
  }
  
  @Test("Fetch Single Quote Test")
  func fetchSingleQuote() async throws {
    // given
    try await quoteRepository.createQuote(DummyData.quote)
    
    // when
    let fetched = try await useCase.fetchQuote(id: DummyData.quote.id)
    
    // then
    #expect(fetched == DummyData.quote)
  }
  
  @Test("Fetch Quotes by ISBN Test")
  func fetchQuotesByISBN() async throws {
    // given
    let other = Quote(
      id: "id-2",
      isbn: DummyData.quote.isbn,
      content: "Other quote",
      page: 1
    )
    try await quoteRepository.createQuote(DummyData.quote)
    try await quoteRepository.createQuote(other)
    
    // when
    let list = try await useCase.fetchQuotes(isbn: DummyData.quote.isbn)
    
    // then
    #expect(list == [DummyData.quote, other])
  }
  
  @Test("Fetch All Quotes Test")
  func fetchAllQuotesTest() async throws {
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
  
  @Test("Validate Page Success Test")
  func validatePageSuccess() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    
    // when
    try await useCase.validatePage(5, forISBN: DummyData.quote.isbn)
  }
  
  @Test("Validate Page Invalid Error Test")
  func validatePageInvalidError() async throws {
    // given
    for book in DummyData.books {
      try await bookRepository.createBook(book)
    }
    let max = DummyData.books
      .first { $0.isbn == DummyData.quote.isbn }!
      .totalPages
    
    // when / then
    await #expect(throws: QuoteUseCaseError.invalidPage(max: max), performing: {
      try await useCase.validatePage(max + 1, forISBN: DummyData.quote.isbn)
    })
  }
}
