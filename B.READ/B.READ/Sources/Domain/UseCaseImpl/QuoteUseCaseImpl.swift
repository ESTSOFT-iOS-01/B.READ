//
//  QuoteUseCaseImpl.swift
//  B.READ
//
//  Created by 도민준 on 5/22/25.
//

import Foundation

final class QuoteUseCaseImpl: QuoteUseCase {
  
  private let quoteRepository: QuoteRepository
  private let bookRepository: BookRepository
  
  /// 생성자
  /// - Parameters:
  ///   - quoteRepo: 문장 저장소 구현체
  ///   - bookRepo: 도서 저장소 구현체(페이지 검증용)
  init(quoteRepository: QuoteRepository, bookRepository: BookRepository) {
    self.quoteRepository = quoteRepository
    self.bookRepository = bookRepository
  }
  
  func saveQuote(_ quote: Quote, in record: Record) async throws {
    do {
      try await quoteRepository.updateQuote(quote)
    } catch RepositoryError.dataNotFound {
      try await quoteRepository.createQuote(quote, in: record)
    }
  }
  
  func removeQuote(id: String) async throws {
    try await quoteRepository.deleteQuote(id: id)
  }
  
  func fetchQuote(id: String) async throws -> Quote {
    return try await quoteRepository.fetchQuote(id: id)
  }
  
  func fetchQuotes(isbn: String) async throws -> [Quote] {
    return try await quoteRepository.fetchQuotes(isbn: isbn)
  }
  
  func fetchAllQuotes() async throws -> [Quote] {
    return try await quoteRepository.fetchAllQuotes()
  }

  func loadBookTitle(_ isbn: String) async throws -> String {
    return try await bookRepository.fetchBook(isbn: isbn).name
  }
}
