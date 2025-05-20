//
//  QuoteRepositoryTest.swift
//  B.READTests
//
//  Created by 도민준 on 5/20/25.
//

import Foundation
import Testing

struct QuoteRepositoryTest {
  
  private var quoteRepository: QuoteRepository
  
  init() {
    quoteRepository = QuoteRepositoryStub()
    let storage = SwiftDataTestStorage()
    quoteRepository = QuoteRepositoryImpl(modelContainer: storage.modelContainer)
  }
  
  
  @Test("Quote Create Test")
  func createUserInfo() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    let fetchedQuote = try await quoteRepository.fetchQuote()
    #expect(fetchedQuote == DummyData.quote)
  }
  
  @Test("Quote Create Error Test - Data Already Exists")
  func createQuoteDataAlreadyExist() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await quoteRepository.createQuote(DummyData.quote)
    })
  }
  
  @Test("Quote Fetch Error Test - Data Not Found")
  func fetchQuotesDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote()
    })
  }
  
  @Test("Quote Update Test")
  func updateQuote() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    
    var updatedQuote = Quote(
      id: DummyData.quote.id,
      isbn: "88888",
      content: "새로운 내용",
      page: 99
    )
    try await quoteRepository.updateQuote(updatedQuote)
    let fetchedQuote = try await quoteRepository.fetchQuote()
    #expect(fetchedQuote == updatedQuote)
  }
  
  @Test("Quote Update Error Test - Data Not Found")
  func updateQuoteDataNotFound() async throws {
    let missing = Quote(
      id: "없음",
      isbn: "없음",
      content: "없음",
      page: 0
    )
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await quoteRepository.updateQuote(missing)
    })
  }
  
  @Test("Quote Delete Test")
  func deleteQuote() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    try await quoteRepository.deleteQuote(DummyData.quote)
    
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote()
    })
  }
  
  @Test("Quote Delete Error Test - Data Not Found")
  func deleteQuoteDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await quoteRepository.deleteQuote(DummyData.quote)
    })
  }
  
}
