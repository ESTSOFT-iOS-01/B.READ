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
  
  func addQuote(_ quote: Quote, in record: Record) async throws {
    // 저장 수행
    try await quoteRepository.createQuote(quote, in: record)
    // UserDefaults에 저장
    try await saveQuotesToSharedDefaults()
  }
  
  func updateQuote(_ quote: Quote) async throws {
    // 업데이트 수행
    try await quoteRepository.updateQuote(quote)
    // UserDefaults에 저장
    try await saveQuotesToSharedDefaults()
  }
  
  func removeQuote(id: String) async throws {
    // 삭제 수행
    try await quoteRepository.deleteQuote(id: id)
    // UserDefaults에 저장
    try await saveQuotesToSharedDefaults()
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
  
  // TODO: - 조회한 도서가 없을 경우 알라딘 검색 후 도서 저장 -> 도서 제목 반환
  func loadBookTitle(_ isbn: String) async throws -> String {
    return try await bookRepository.fetchBook(isbn: isbn).name
  }
  
  func saveQuotesToSharedDefaults() async throws {
    let allQuotes = try await fetchAllQuotes() // 이미 구현된 메서드 사용
    let quoteContents = allQuotes.map { $0.content }
    
    let sharedDefaults = UserDefaults(suiteName: "group.BREAD")
    sharedDefaults?.set(quoteContents, forKey: "quotes")
    
    print("quotes 저장 완료: \(quoteContents)")
  }
}
