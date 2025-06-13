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
  private let bookService: BookService
  
  /// 생성자
  /// - Parameters:
  ///   - quoteRepo: 문장 저장소 구현체
  ///   - bookRepo: 도서 저장소 구현체(페이지 검증용)
  init(
    userInfoRepository: UserInfoRepository,
    quoteRepository: QuoteRepository,
    bookRepository: BookRepository,
    bookService: BookService
  ) {
    self.userInfoRepository = userInfoRepository
    self.quoteRepository = quoteRepository
    self.bookRepository = bookRepository
    self.bookService = bookService
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

  func loadBookTitle(_ isbn: String) async throws -> String {
    do {
      return try await bookRepository.fetchBook(isbn: isbn).name
    } catch RepositoryError.dataNotFound {
      // 도서 정보가 없다면 알라딘에서 검색 후 정보 생성하고 도서제목을 반환
      // 1. 알라딘에서 정보를 패치
      let bookDetail = try await bookService.fetchBookDetail(isbn: isbn)
      
      // 2. 패치한 정보로 엔티티 생성
      var book = Book(
        isbn: bookDetail.isbn,
        coverImage: nil,
        name: bookDetail.title,
        author: bookDetail.author,
        publisher: bookDetail.publisher,
        publishedAt: bookDetail.publishedDate.toDate() ?? .now,
        totalPages: bookDetail.pageCount
      )
      
      // 3. 표지정보 업데이트
      if let url = URL(string: bookDetail.coverURL) {
        let data = try? Data(contentsOf: url)
        book.coverImage = data
      }
      
      // 4. 책정보 생성
      try? await bookRepository.createBook(book)
      // 5. 책 생성에 실패하든 성공하든 새로운 책제목을 반환
      return book.name
    }
  }
}

private extension QuoteUseCaseImpl {
  func updateStreakIfNeeded() async throws {
    let currentTime: Date = .now
    
    var userInfo = try await userInfoRepository.fetchUserInfo()
    // 같은 날짜에 이미 업데이트가 이루어졌다면 return
    if userInfo.lastStreakUpdatedAt.isSameDay(as: currentTime) { return }
    
    // 스트릭이 이번주의 첫 스트릭일 경우 초기화
    if !userInfo.lastStreakUpdatedAt.isInCurrentWeek {
      userInfo.streak = userInfo.streak.map { DailyStatus(weekday: $0.weekday, isCompleted: false) }
    }
    
    // 업데이트
    userInfo.streak[currentTime.weekdayInt - 1] = DailyStatus(weekday: currentTime.weekdayInt - 1, isCompleted: true)
    userInfo.lastStreakUpdatedAt = currentTime
    
    try await userInfoRepository.updateUserInfo(userInfo)
  }
}
