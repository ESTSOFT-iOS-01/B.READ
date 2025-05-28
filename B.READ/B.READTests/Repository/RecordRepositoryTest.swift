//
//  RecordRepositoryTest.swift
//  B.READTests
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import Testing

struct RecordRepositoryTest {
  
  private let recordRepository: RecordRepository
  
  init() {
//    recordRepository = RecordRepositoryStub()
    let storage = SwiftDataTestStorage()
    recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
  }
  
  @Test("Record Create Test")
  func createRecord() async throws {
    let fetchedRecord = DummyData.records[0]
    try await recordRepository.createRecord(DummyData.records[0])
    
    let record = try await recordRepository.fetchAllRecord().first
    #expect(record == fetchedRecord)
  }
  
  @Test("Record Create Error Test - Data Already Exists")
  func createRecordDataAlreadyExist() async throws {
    try await recordRepository.createRecord(DummyData.records[0])
    
    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await recordRepository.createRecord(DummyData.records[0])
    })
  }
  
  @Test("Record Fetch Test")
  func fetchRecord() async throws {
    let record = DummyData.records[0]
    try await recordRepository.createRecord(record)
    
    let fetchedRecord = try await recordRepository.fetchRecord(id: record.id)
    #expect(record == fetchedRecord)
  }
  
  @Test("Record Fetch Error Test - Data Not Found")
  func fetchRecordDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await recordRepository.fetchRecord(id: "111")
    })
  }
  
  
  @Test("Recent Reading Record Fetch Test")
  func fetchRecentReadingRecord() async throws {
    let fetchedRecords = DummyData.records
      .filter { $0.state == .reading }
      .sorted { $0.updatedAt > $1.updatedAt }
    
    for record in DummyData.records {
      try await recordRepository.createRecord(record)
    }
    
    let fetchRecords = try await recordRepository.fetchRecentReadingRecord(maxCount: 3)
    #expect(fetchedRecords == fetchRecords)
  }
  
  
  @Test("Record Update Test")
  func updateRecord() async throws {
    // 초기의 레코드
    var basicRecord = DummyData.records[0]
    // 최종의 레코드
    let updatedRecord = Record(
      id: basicRecord.id,
      isbn: basicRecord.isbn,
      state: .completed,
      heartCount: basicRecord.heartCount,
      starCount: 4,
      isFavorite: basicRecord.isFavorite,
      period: basicRecord.period,
      currentPage: basicRecord.currentPage,
      review: basicRecord.review,
      memoIDs: basicRecord.memoIDs,
      quoteIDs: basicRecord.quoteIDs,
      createdAt: basicRecord.createdAt,
      updatedAt: basicRecord.updatedAt
    )
    // 초기의 레코드를 저장
    try await recordRepository.createRecord(basicRecord)
    
    // 초기의 레코드의 값을 수정
    basicRecord.state = .completed
    basicRecord.starCount = 4
    // 수정한 레코드를 저장
    try await recordRepository.updateRecord(basicRecord)
    // 패치한 값이랑 최종의 레코드와 같은지 비교
    let fetchRecords = try await recordRepository.fetchAllRecord()
    #expect([updatedRecord] == fetchRecords)
  }
  
  @Test("Record Update Error Test - Data Not Found")
  func updateRecordDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await recordRepository.updateRecord(DummyData.records[0])
    })
  }
  
  @Test("Record Delete Test")
  func deleteRecord() async throws {
    let record = DummyData.records[0]
    try await recordRepository.createRecord(record)
    
    try await recordRepository.deleteRecord(record.id)
    let records = try await recordRepository.fetchAllRecord()
    #expect(records == [])
  }
  
  @Test("Record Delete Error Test - Data Not Found")
  func RecordDeleteDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await recordRepository.deleteRecord(DummyData.records[0].id)
    })
  }
}
