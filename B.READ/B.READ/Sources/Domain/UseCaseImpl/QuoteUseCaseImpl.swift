//
//  QuoteUseCaseImpl.swift
//  B.READ
//
//  Created by 도민준 on 5/22/25.
//

import Foundation

final class QuoteUseCaseImpl: QuoteUseCase {
  
  private let userInfoRepository: UserInfoRepository
  private let quoteRepository: QuoteRepository
  private let bookRepository: BookRepository
  
  /// 생성자
  /// - Parameters:
  ///   - quoteRepo: 문장 저장소 구현체
  ///   - bookRepo: 도서 저장소 구현체(페이지 검증용)
  init(
    userInfoRepository: UserInfoRepository,
    quoteRepository: QuoteRepository,
    bookRepository: BookRepository
  ) {
    self.userInfoRepository = userInfoRepository
    self.quoteRepository = quoteRepository
    self.bookRepository = bookRepository
  }
  
  func saveQuote(_ quote: Quote, in record: Record) async throws {
    do {
      try await quoteRepository.updateQuote(quote)
    } catch RepositoryError.dataNotFound {
      try await quoteRepository.createQuote(quote, in: record)
    }
    
    try await self.updateStreakIfNeeded()
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

  
  // TODO: - 조회한 도서가 없을 경우 알라딘 검색 후 도서 저장 -> 도서 제목 반환
  func loadBookTitle(_ isbn: String) async throws -> String {
    return try await bookRepository.fetchBook(isbn: isbn).name
  }
}

private extension QuoteUseCaseImpl {
  func updateStreakIfNeeded() async throws {
    let currentTime: Date = .now
    
    var userInfo = try await userInfoRepository.fetchUserInfo()
    // 같은 날짜에 이미 업데이트가 이루어졌다면 return
    if userInfo.lastStreakUpdatedAt.isSameDay(as: currentTime) { return }
    
    // 스트릭이 이번주의 첫 스트릭일 경우 초기화
    if userInfo.lastStreakUpdatedAt.isInCurrentWeek {
      userInfo.streak = userInfo.streak.map { DailyStatus(weekday: $0.weekday, isCompleted: false) }
    }
    
    // 업데이트
    userInfo.streak[currentTime.weekdayInt - 1] = DailyStatus(weekday: currentTime.weekdayInt - 1, isCompleted: true)
    userInfo.lastStreakUpdatedAt = currentTime
    
    try await userInfoRepository.updateUserInfo(userInfo)
  }
}
