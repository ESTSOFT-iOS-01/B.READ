//
//  QuoteUseCaseTest.swift
//  B.READTests
//
//  Created by 도민준 on 5/22/25.
//

import Foundation
import Testing

@testable import B_READ

struct QuoteUseCaseTest {
  
  private let quoteUseCase: QuoteUseCase
  private let userInfoRepository: UserInfoRepository
  private let bookRepository: BookRepository
  private let recordRepository: RecordRepository
  private let quoteRepository: QuoteRepository
  
  init() {
    let storage = SwiftDataTestStorage()
    self.userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
    self.bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    self.recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    self.quoteRepository = QuoteRepositoryImpl(modelContainer: storage.modelContainer)
    
    self.quoteUseCase = QuoteUseCaseImpl(
      userInfoRepository: userInfoRepository,
      quoteRepository: quoteRepository,
      bookRepository: bookRepository
    )
  }
  
  @Test("Quote Create & Id Fetch Test")
  func saveQuoteTestCreate() async throws {
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 1. 레코드와 문장을 각각 생성
    try await recordRepository.createRecord(dummyRecord)
    try await quoteUseCase.saveQuote(dummyQuote, in: dummyRecord)
    
    // 2. 레코드 패치
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장 패치
    let fetchedQuote = try await quoteUseCase.fetchQuote(id: dummyQuote.id)
    
    // 4. 레코드의 문장과 패치한 문장이 같은지 비교
    #expect(fetchedQuote == fetchedRecord.quotes.first)
  }
  
  @Test("Quote Update Test")
  func saveQuoteTestUpdate() async throws {
    let dummyRecord = DummyData.dummyRecords[1]
    var dummyQuote = DummyData.dummyQuote[0]
    
    // 1. 레코드와 문장을 각각 생성
    try await recordRepository.createRecord(dummyRecord)
    try await quoteUseCase.saveQuote(dummyQuote, in: dummyRecord)
    
    // 2. 생성한 문장을 수정
    dummyQuote.content = "수정된 문장입니다."
    dummyQuote.page = 100
    
    // 3. 수정한 문장을 업데이트
    try await quoteUseCase.saveQuote(dummyQuote, in: dummyRecord)
    
    // 4. 레코드 패치
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 5. 문장 패치
    let fetchedQuote = try await quoteUseCase.fetchQuote(id: dummyQuote.id)
    
    // 6. 레코드의 문장과 패치한 문장이 같은지 비교
    #expect(fetchedQuote == fetchedRecord.quotes.first)
  }
  
  @Test("Quote Remove & AllCase Fetch Test")
  func removeQuoteTest() async throws {
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 1. 레코드와 문장을 각각 생성
    try await recordRepository.createRecord(dummyRecord)
    try await quoteUseCase.saveQuote(dummyQuote, in: dummyRecord)
    
    // 2. 문장을 삭제
    try await quoteUseCase.removeQuote(id: dummyQuote.id)
    
    // 3. 정상적인 삭제일 시, id로 패치하면 에러발생 - data not found
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteUseCase.fetchQuote(id: dummyQuote.id)
    })
    
    // 4. 정상적인 삭제일 시, all 패치하면 빈배열([])
    let fetchedQuotes1 = try await quoteUseCase.fetchAllQuotes()
    #expect(fetchedQuotes1 == [])
    
    // 5. 정상적인 삭제일 시, isbn으로 패치하면 빈배열([])
    let fetchedQuotes2 = try await quoteUseCase.fetchQuotes(isbn: dummyRecord.isbn)
    #expect(fetchedQuotes2 == [])
    
    // 6. 정상적인 삭제일 시, 레코드의 Quote는 빈배열([])
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(fetchedRecord.quotes == [])
  }
  
  @Test("Load Book Title Test")
  func loadBookTitleTest() async throws {
    
    let dummyBook = DummyData.dummyBooks[1]
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 1. 책정보, 레코드, 문장을 각각 생성
    try await bookRepository.createBook(dummyBook)
    try await recordRepository.createRecord(dummyRecord)
    try await quoteUseCase.saveQuote(dummyQuote, in: dummyRecord)
    
    // 2. 레코드를 패치한 후 레코드의 책정보 패치
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    let fetchedBookWithRecord = try await bookRepository.fetchBook(isbn: fetchedRecord.isbn)
    
    // 3. 레코드의 문장 정보를 가지고 문장 패치
    let quoteInRecord = fetchedRecord.quotes[0]
    let fetchedQuote = try await quoteUseCase.fetchQuote(id: quoteInRecord.id)
    
    // 4. 패치 해온 문장으로 책 정보 패치
    let fetchedBookWithQuote = try await quoteUseCase.loadBookTitle(fetchedQuote.isbn)
    
    #expect(fetchedBookWithRecord.name == fetchedBookWithQuote)
  }
}
