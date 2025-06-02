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
  
  // TODO: - 도로시
  @Test("Save Record Test")
  func saveRecordTest() async throws {
    
  }
  
  @Test("Load Record Test")
  func loadRecordTest() async throws {
    // 1. 레코드, 책 정보
    let book = DummyData.dummyBooks[0]
    let record = DummyData.dummyRecords[0]
    
    // 2. 레코드, 책 생성
    try await bookRepository.createBook(book)
    try await recordRepository.createRecord(record)
    
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
  
  @Test("Load Recent Updated Reading Record Test")
  func loadRecentUpdatedReadingRecordTest() async throws {
    
  }
  
  
//
//  @Test("Edit Record Test")
//  func editRecordTest() async throws {
//    try await recordRepository.createRecord(DummyData.records[0])
//    try await bookRepository.createBook(DummyData.books[0])
//    
//    let updatedRecord = Record(
//      id: DummyData.records[0].id,
//      isbn: DummyData.records[0].isbn,
//      state: ReadState.reading,
//      heartCount: 4,
//      starCount: 4,
//      isFavorite: true,
//      currentPage: 200,
//      review: "",
//      memoIDs: [],
//      quoteIDs: [],
//      createdAt: DummyData.records[0].createdAt,
//      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20))!
//    )
//    
//    try await libraryUseCase.editRecord(updatedRecord)
//    let fetchedRecord = try await libraryUseCase.loadRecord(updatedRecord.id).0
//    
//    #expect(fetchedRecord == updatedRecord)
//  }
//  
//  @Test("Edit Record Test - Data Not Found")
//  func editRecordDataNotFoundTest() async throws {
//    // 1. 책만 등록된 상태
//    try await bookRepository.createBook(DummyData.books[0])
//    let updatedRecord = Record(
//      id: DummyData.records[0].id,
//      isbn: DummyData.records[0].isbn,
//      state: ReadState.reading,
//      heartCount: 4,
//      starCount: 4,
//      isFavorite: true,
//      currentPage: 200,
//      review: "",
//      memoIDs: [],
//      quoteIDs: [],
//      createdAt: DummyData.records[0].createdAt,
//      updatedAt: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20))!
//    )
//    // 2. 독서 기록을 수정 - 수정할 기록이 없기 때문에 새로 만듦
//    try await libraryUseCase.editRecord(updatedRecord)
//    let fetchedRecord = try await libraryUseCase.loadRecord(updatedRecord.id).0
//    // 3. 정상적으로 새로 만들어졌는지 확인
//    #expect(updatedRecord == fetchedRecord)
//  }
//  
//  @Test("Delete Record Test")
//  func deleteRecordTest() async throws {
//    try await recordRepository.createRecord(DummyData.records[0])
//    try await bookRepository.createBook(DummyData.books[0])
//    
//    try await libraryUseCase.deleteRecord(DummyData.records[0])
//    
//    await #expect(throws: RepositoryError.dataNotFound, performing: {
//      let _ = try await libraryUseCase.loadRecord(DummyData.records[0].id)
//    })
//  }
//  
//  @Test("Load Record Test")
//  func loadRecordTest() async throws {
//    try await recordRepository.createRecord(DummyData.records[0])
//    try await bookRepository.createBook(DummyData.books[0])
//    
//    let info: (record: Record, book: Book)
//    = try await libraryUseCase.loadRecord(DummyData.records[0].id)
//    let record = info.record
//    
//    #expect(record == DummyData.records[0])
//  }
//  
//  @Test("Load Record List Test")
//  func loadRecordListTest() async throws {
//    let fetchedRecordList = [
//      DummyData.records[0],
//      DummyData.records[1],
//      DummyData.records[2]
//    ]
//    
//    try await recordRepository.createRecord(DummyData.records[0])
//    try await recordRepository.createRecord(DummyData.records[1])
//    try await recordRepository.createRecord(DummyData.records[2])
//    
//    try await bookRepository.createBook(DummyData.books[0])
//    try await bookRepository.createBook(DummyData.books[1])
//    try await bookRepository.createBook(DummyData.books[2])
//    
//    let infos: [(record: Record, book: Book)] = try await libraryUseCase.loadRecordList()
//    let infoRecords = infos.map { $0.record }.sorted { $0.createdAt > $1.createdAt }
//    
//    #expect(fetchedRecordList == infoRecords)
//  }
//  
//  @Test("Load Recent Updated Reading Record Test")
//  func loadRecentUpdatedReadingRecordTest() async throws {
//    
//  }
}
