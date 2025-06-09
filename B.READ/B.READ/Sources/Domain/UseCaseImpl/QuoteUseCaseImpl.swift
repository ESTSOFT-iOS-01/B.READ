//
//  QuoteUseCaseImpl.swift
//  B.READ
//
//  Created by 도민준 on 5/22/25.
//

import Foundation
import WidgetKit

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
    try await syncSharedDefaults()
  }
  
  func updateQuote(_ quote: Quote) async throws {
    // 업데이트 수행
    try await quoteRepository.updateQuote(quote)
    try await syncSharedDefaults()
  }
  
  func removeQuote(id: String) async throws {
    // 삭제 수행
    try await quoteRepository.deleteQuote(id: id)
    try await syncSharedDefaults()
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
  
  /// 모든 `Quote` → `SharedQuote` 로 변환한 뒤
  /// App Group(UserDefaults) 에 저장하고 위젯 타임라인을 즉시 갱신.
  ///
  /// 1. 저장소에서 모든 Quote 를 가져옴.
  /// 2. ISBN → 책 제목을 비동기로 조회하여 `SharedQuote` 생성
  /// 3. `SharedQuotesStore.save(_:)` 호출로 JSON 덤프
  /// 4. `WidgetCenter.shared.reloadAllTimelines()` 로 위젯 갱신
  ///
  /// - Throws:
  ///   - `RepositoryError.fetchError` : Quote 또는 Book 로드 과정에서 발생
  ///   - `EncodingError` : JSON 인코딩 실패
  private func syncSharedDefaults() async throws {
    let allQuotes = try await quoteRepository.fetchAllQuotes()
    
    let sharedQuotes: [SharedQuote] = try await withThrowingTaskGroup(of: SharedQuote.self) { group in
      for quote in allQuotes {
        group.addTask {
          let title = try? await self.loadBookTitle(quote.isbn)
          return SharedQuote(
            id: quote.id,
            content: quote.content,
            bookTitle: title ?? ""          // 제목 없으면 빈 문자열
          )
        }
      }
      return try await group.reduce(into: []) { $0.append($1) }
    }
    
    try SharedQuotesStore.save(sharedQuotes)
    
    // 새로운 데이터가 쓰였으니 위젯 타임라인 즉시 갱신
    WidgetCenter.shared.reloadAllTimelines()
  }
}
