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
  private let recordRepository: RecordRepository

  init() {
    // let stub = QuoteRepositoryStub()
    // quoteRepository = stub

    let storage = SwiftDataTestStorage()
    quoteRepository = QuoteRepositoryImpl(modelContainer: storage.modelContainer)
    recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
  }

  @Test("Quote Create and Fetch Test")
  func createQuote() async throws {
    // 1. 생성할 레코드와 문장
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 2. 레코드를 생성
    try await recordRepository.createRecord(dummyRecord)
    var fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장을 생성
    try await quoteRepository.createQuote(dummyQuote, in: fetchedRecord)
    let fetchedQuote = try await quoteRepository.fetchQuote(id: dummyQuote.id)
    
    // 4. Quote 생성 및 패치 확인
    #expect(fetchedQuote == dummyQuote)
    
    // 5. Record에 저장됐는지 확인
    fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(fetchedRecord.quotes.first! == fetchedQuote)
  }

  @Test("Quote Create Error Test - Data Already Exists")
  func createQuoteDataAlreadyExist() async throws {
    // 1. 생성할 레코드와 문장
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 2. 레코드를 생성
    try await recordRepository.createRecord(dummyRecord)
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장을 생성
    try await quoteRepository.createQuote(dummyQuote, in: fetchedRecord)
    
    // 4. 3번에서 생성한 문장을 한번 더 생성 -> Data Already Exist 에러 발생
    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await quoteRepository.createQuote(dummyQuote, in: fetchedRecord)
    })
  }

  @Test("Quote Fetch Error Test - Data Not Found")
  func fetchQuoteDataNotFound() async throws {
    // 1. 데이터를 패치 -> Data Not Found 에러 발생
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote(id: "NotFoundId")
    })
  }
  
  @Test("Fetch Quotes by ISBN")
  func fetchQuotesByISBN() async throws {
    // 1. 생성할 레코드와 문장
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuotes = [
      DummyData.dummyQuote[0],
      DummyData.dummyQuote[1],
      DummyData.dummyQuote[2]
    ]
    
    // 2. 레코드를 생성
    try await recordRepository.createRecord(dummyRecord)
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장을 생성
    for quote in dummyQuotes {
      try await quoteRepository.createQuote(quote, in: fetchedRecord)
    }
    
    // 4. ISBN을 가지고 문장을 패치
    let fetchedQuotes = try await quoteRepository.fetchQuotes(isbn: fetchedRecord.isbn).sorted { $0.id < $1.id }
    
    // 5. 패치해온 문장과 더미 문장을 비교
    #expect(fetchedQuotes == dummyQuotes)
  }
  
  @Test("Fetch All Quotes Test")
  func fetchAllQuotes() async throws {
    // 1. 생성할 레코드와 문장
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuotes = [
      DummyData.dummyQuote[0],
      DummyData.dummyQuote[1],
      DummyData.dummyQuote[2]
    ]
    
    // 2. 레코드를 생성
    try await recordRepository.createRecord(dummyRecord)
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장을 생성
    for quote in dummyQuotes {
      try await quoteRepository.createQuote(quote, in: fetchedRecord)
    }
    
    // 4. ISBN을 가지고 문장을 패치
    let fetchedQuotes = try await quoteRepository.fetchAllQuotes().sorted { $0.id < $1.id }
    
    // 5. 패치해온 문장과 더미 문장을 비교
    #expect(fetchedQuotes == dummyQuotes)
  }

  @Test("Quote Update Test")
  func updateQuote() async throws {
    
    // 1. 생성할 레코드와 문장
    let dummyRecord = DummyData.dummyRecords[1]
    var dummyQuote = DummyData.dummyQuote[0]
    
    // 2. 레코드를 생성
    try await recordRepository.createRecord(dummyRecord)
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장을 생성
    try await quoteRepository.createQuote(dummyQuote, in: fetchedRecord)
    
    // 4. 문장을 수정
    dummyQuote.content = "수정한 문장입니다."
    dummyQuote.page = 100
    
    // 5. 수정한 문장을 업데이트
    try await quoteRepository.updateQuote(dummyQuote)
    
    // 6. 문장을 패치
    let fetchedQuote = try await quoteRepository.fetchQuote(id: dummyQuote.id)
    
    #expect(fetchedQuote == dummyQuote)
  }

  @Test("Quote Update Error Test - Data Not Found")
  func updateQuoteDataNotFound() async throws {
    // 1. 수정할 문장
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 2. 문장 수정을 시도 -> Data Not Found 에러 발생
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await quoteRepository.updateQuote(dummyQuote)
    })
  }

  @Test("Quote Delete Test")
  func deleteQuote() async throws {
    // 1. 생성할 레코드와 문장
    let dummyRecord = DummyData.dummyRecords[1]
    let dummyQuote = DummyData.dummyQuote[0]
    
    // 2. 레코드를 생성
    try await recordRepository.createRecord(dummyRecord)
    let fetchedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    // 3. 문장을 생성
    try await quoteRepository.createQuote(dummyQuote, in: fetchedRecord)
    let fetchedQuote = try await quoteRepository.fetchQuote(id: dummyQuote.id)
    
    // 4. 문장을 삭제
    try await quoteRepository.deleteQuote(id: fetchedQuote.id)
    
    // 5. 패치를 시도 -> Data Not Found 에러 발생
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await quoteRepository.fetchQuote(id: fetchedQuote.id)
    })
  }

  @Test("Quote Delete Error Test - Data Not Found")
  func deleteQuoteDataNotFound() async throws {
    // 1. 삭제를 시도 -> Data Not Found 에러 발생
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await quoteRepository.deleteQuote(id: "NotFoundId")
    })
  }
}
