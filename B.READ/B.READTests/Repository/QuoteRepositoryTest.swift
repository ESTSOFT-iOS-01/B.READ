//
//  QuoteRepositoryTest.swift
//  B.READTests
//
//  Created by 도민준 on 5/20/25.
//

import Foundation
import Testing
@testable import B_READ

struct QuoteRepositoryTest {
  private let quoteRepository: QuoteRepository

  init() {
    // let stub = QuoteRepositoryStub()
    // quoteRepository = stub

    let storage = SwiftDataTestStorage()
    quoteRepository = QuoteRepositoryImpl(modelContainer: storage.modelContainer)
  }

  @Test("Quote Create Test")
  func createQuote() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    let fetched = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    #expect(fetched == DummyData.quote)
  }

  @Test("Quote Create Error Test - Data Already Exists")
  func createQuoteDataAlreadyExist() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await quoteRepository.createQuote(DummyData.quote)
    })
  }

  @Test("Quote Fetch Error Test - Data Not Found")
  func fetchQuoteDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote(id: "non-existent-id")
    })
  }

  @Test("Quote Update Test")
  func updateQuote() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    let updated = Quote(
      id: DummyData.quote.id,
      isbn: "updated-isbn",
      content: "새로운 내용",
      page: 99
    )
    try await quoteRepository.updateQuote(updated)
    let fetched = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    #expect(fetched == updated)
  }

  @Test("Quote Update Error Test - Data Not Found")
  func updateQuoteDataNotFound() async throws {
    let missing = Quote(
      id: "missing-id",
      isbn: "none",
      content: "none",
      page: 0
    )
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await quoteRepository.updateQuote(missing)
    })
  }

  @Test("Quote Delete Test")
  func deleteQuote() async throws {
    try await quoteRepository.createQuote(DummyData.quote)
    try await quoteRepository.deleteQuote(id: DummyData.quote.id)
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote(id: DummyData.quote.id)
    })
  }

  @Test("Quote Delete Error Test - Data Not Found")
  func deleteQuoteDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await quoteRepository.deleteQuote(id: "missing-id")
    })
  }
}
