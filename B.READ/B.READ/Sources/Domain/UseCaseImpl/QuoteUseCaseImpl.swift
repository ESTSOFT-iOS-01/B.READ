//
//  QuoteUseCaseImpl.swift
//  B.READ
//
//  Created by 도민준 on 5/22/25.
//


final class QuoteUseCaseImpl: QuoteUseCase {
  private let quoteRepo: QuoteRepository
  private let bookRepo: BookRepository

  /// 생성자
  /// - Parameters:
  ///   - quoteRepo: 문장 저장소 구현체
  ///   - bookRepo: 도서 저장소 구현체(페이지 검증용)
  init(quoteRepo: QuoteRepository, bookRepo: BookRepository) {
    self.quoteRepo = quoteRepo
    self.bookRepo = bookRepo
  }

  func addQuote(_ quote: Quote) async throws {
    // 빈 내용 검증
    let content = quote.content.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !content.isEmpty else {
      throw QuoteUseCaseError.emptyContent
    }
    // 페이지 범위 검증
    try await validatePage(quote.page, forISBN: quote.isbn)
    // 저장 수행
    try await quoteRepo.createQuote(quote)
  }

  func updateQuote(_ quote: Quote) async throws {
    // 빈 내용 검증
    let content = quote.content.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !content.isEmpty else {
      throw QuoteUseCaseError.emptyContent
    }
    // 페이지 범위 검증
    try await validatePage(quote.page, forISBN: quote.isbn)
    // 업데이트 수행
    try await quoteRepo.updateQuote(quote)
  }

  func removeQuote(id: String) async throws {
    // 삭제 수행
    try await quoteRepo.deleteQuote(id: id)
  }

  func fetchQuote(id: String) async throws -> Quote {
    return try await quoteRepo.fetchQuote(id: id)
  }

  func fetchQuotes(isbn: String) async throws -> [Quote] {
    return try await quoteRepo.fetchQuotes(isbn: isbn)
  }

  func fetchAllQuotes() async throws -> [Quote] {
    return try await quoteRepo.fetchAllQuotes()
  }

  func validatePage(_ page: Int, forISBN isbn: String) async throws {
    let book = try await bookRepo.fetchBook(isbn: isbn)
    let max = book.totalPages
    guard (1...max).contains(page) else {
      throw QuoteUseCaseError.invalidPage(max: max)
    }
  }
}