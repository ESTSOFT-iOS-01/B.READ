//
//  LibraryUseCaseTest.swift
//  B.READTests
//
//  Created by 심근웅 on 5/26/25.
//

import Foundation
import Testing

@testable import B_READ

struct LibraryUseCaseTest {
  
  private let libraryUseCase: LibraryUseCase
  
  private let recordRepository: RecordRepository
  private let bookRepository: BookRepository
  private let quoteRepository: QuoteRepository
  private let bookService: BookService
  
  init() {
    let storage = SwiftDataTestStorage()
    
    recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    quoteRepository = QuoteRepositoryImpl(modelContainer: storage.modelContainer)
    bookService = AladinService(client: MockNetworkClient(nextMockFileName: "SearchList"))
    
    libraryUseCase = LibraryUseCaseImpl(
      bookRepository: bookRepository ,
      recordRepository: recordRepository,
      quoteRepository: quoteRepository,
      bookService: bookService
    )
  }
  
  @Test("Save/Load Record Test")
  func loadRecordTest() async throws {
    // 1. 레코드, 책 정보
    let book = DummyData.dummyBooks[0]
    let record = DummyData.dummyRecords[0]
    
    // 2. 레코드, 책 생성
    try await libraryUseCase.saveRecord(record: record, book: book)
    
    // 3. 레코드 책 패치
    let fetchedInfo = try await libraryUseCase.loadRecord(record.id)
    
    #expect(fetchedInfo.0.id == record.id)
    #expect(fetchedInfo.0.createdAt == record.createdAt)
  }
  
  @Test("Load Record List Test")
  func loadRecordListTest() async throws {
    // 1. 레코드들 생성
    let infos: [(Record, Book)] = [
      (DummyData.dummyRecords[0], DummyData.dummyBooks[0]),
      (DummyData.dummyRecords[1], DummyData.dummyBooks[1]),
      (DummyData.dummyRecords[2], DummyData.dummyBooks[2])
    ].sorted { $0.0.createdAt > $1.0.createdAt }
    for info in infos {
      try await libraryUseCase.saveRecord(record: info.0, book: info.1)
    }
    
    // 2. 레코드들 패치
    let fetchedInfos = try await libraryUseCase.loadRecordList()
      .sorted { $0.0.createdAt > $1.0.createdAt }
    for (info, fetchedInfo) in zip(infos, fetchedInfos) {
      #expect(info.0.id == fetchedInfo.0.id)
      #expect(info.0.state == fetchedInfo.0.state)
    }
    
  }
  
  @Test("Delete Record Test")
  func deleteRecordTest() async throws {
    // 1. 레코드 정보
    let book = DummyData.dummyBooks[0]
    let record = DummyData.dummyRecords[0]
    
    // 2. 레코드, 책 생성
    try await libraryUseCase.saveRecord(record: record, book: book)
    
    // 3. 레코드 삭제
    try await libraryUseCase.deleteRecord(record)
    
    // 4. 레코드 패치
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      let _ = try await libraryUseCase.loadRecord(record.id)
    })
  }
  
  @Test("Edit Record Test")
  func editRecordTest() async throws {
    // 1. 레코드 정보
    let book = DummyData.dummyBooks[0]
    var record = DummyData.dummyRecords[0]
    
    // 2. 레코드, 책 생성
    try await libraryUseCase.saveRecord(record: record, book: book)
    
    // 3. 레코드 정보 수정
    record.isFavorite = true
    record.state = .completed
    record.starCount = 5
    
    // 4. 수정한 레코드 업데이트
    try await libraryUseCase.editRecord(record)
    
    // 5. 레코드, 책 패치
    let fetchedInfo = try await libraryUseCase.loadRecord(record.id)
    
    #expect(fetchedInfo.0.id == record.id)
    #expect(fetchedInfo.0.createdAt == record.createdAt)
    #expect(fetchedInfo.0.state == record.state)
    #expect(fetchedInfo.0.starCount == record.starCount)
  }
  
  @Test("Edit Record Test - Record Data Not Found")
  func editRecordDataNotFoundTest() async throws {
    // 1. 레코드 정보
    let book = DummyData.dummyBooks[0]
    var record = DummyData.dummyRecords[0]
    
    // 2. 도서만 생성
    try await bookRepository.createBook(book)
    
    // 3. 레코드 정보 수정
    record.isFavorite = true
    record.state = .completed
    record.starCount = 5
    
    // 4. 수정한 레코드 업데이트
    try await libraryUseCase.editRecord(record)
    
    // 5. 레코드, 책 패치
    let fetchedInfo = try await libraryUseCase.loadRecord(record.id)
    
    #expect(fetchedInfo.0.id == record.id)
    #expect(fetchedInfo.0.createdAt == record.createdAt)
    #expect(fetchedInfo.0.state == record.state)
    #expect(fetchedInfo.0.starCount == record.starCount)
  }
  
  @Test("loadRecentUpdatedReadingRecord Test")
  func loadRecentUpdatedReadingRecordTest() async throws {
    // 1. 레코드들 생성
    let infos: [(Record, Book)] = [
      (DummyData.dummyRecords[0], DummyData.dummyBooks[0]),
      (DummyData.dummyRecords[1], DummyData.dummyBooks[1]),
      (DummyData.dummyRecords[2], DummyData.dummyBooks[2])
    ].sorted { $0.0.createdAt > $1.0.createdAt }
    for info in infos {
      try await libraryUseCase.saveRecord(record: info.0, book: info.1)
    }
    
    // 2. 최근 업데이트한 읽는 중 상태의 독서 기록 패치
    let fetchedList = try await libraryUseCase.loadRecentUpdatedReadingRecord(maxCount: 3)
    
    // 3. 기대되는 결과
    let predictList = Array(infos
      .filter { $0.0.state == .reading }
      .sorted { $0.0.updatedAt > $1.0.updatedAt }
      .prefix(3))
    
    #expect(fetchedList[0] == predictList[0])
    
  }
}
