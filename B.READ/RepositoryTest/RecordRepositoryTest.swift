//
//  RecordRepositoryTest.swift
//  B.READTests
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import Testing

@testable import B_READ

struct RecordRepositoryTest {

  private let recordRepository: RecordRepository
  
  init() {
    ////    recordRepository = RecordRepositoryStub()
    let storage = SwiftDataTestStorage()
    recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
  }
  
  @Test("Record Create Test")
  func createRecord() async throws {
    // 1. 생성할 레코드
    let record = DummyData.dummyRecords[0]
    
    // 2. 레코드 생성
    try await recordRepository.createRecord(record)
    
    // 3. 레코드 정보를 가져옴
    let fetchedRecord1 = try await recordRepository.fetchRecord(id: record.id) // id로 한개만 패치
    let fetchedRecord2 = try await recordRepository.fetchAllRecord().first // 전체 패치
    
    #expect(fetchedRecord1 == record)
    #expect(fetchedRecord2 == record)
  }
  
  @Test("Record Create Error Test - Data Already Exists")
  func createRecordDataAlreadyExist() async throws {
    // 1. 생성할 레코드
    let record = DummyData.dummyRecords[0]
    
    // 2. 레코드 생성
    try await recordRepository.createRecord(record)
    
    // 3. 레코드 중복 생성 - 에러 발생
    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await recordRepository.createRecord(record)
    })
  }
  
  @Test("Record Fetch Error Test - Data Not Found")
  func fetchRecordDataNotFound() async throws {
    // 1. 데이터를 패치하지만, 데이터를 못찾음
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await recordRepository.fetchRecord(id: "1")
    })
  }
  
  @Test("Recent Reading Record Fetch Test")
  func fetchRecentReadingRecord() async throws {
    // 1. 생성할 레코드들
    let records = DummyData.dummyRecords
    
    // 2. 레코드 생성
    for record in records {
      try await recordRepository.createRecord(record)
    }
    
    // 3. 읽는 중 상태의 최근 업데이트한 최대 3개의 레코드
    let fetchedRecord = try await recordRepository.fetchRecentReadingRecord(maxCount: 3)
    
    // 4. 패치 결과로 예상되는 레코드들
    let predictResult = Array(records
      .filter { $0.state == .reading }
      .sorted { $0.updatedAt > $1.updatedAt}
      .prefix(3)
    )
    
    #expect(fetchedRecord == predictResult)
  }
  
  @Test("Record Delete Test")
  func deleteRecord() async throws {
    // 1. 넣어둘 레코드
    let record = DummyData.dummyRecords[0]
    try await recordRepository.createRecord(record)
    
    // 2. 넣어둔 레코드를 삭제
    try await recordRepository.deleteRecord(record.id)
    
    // 3. 저장중인 레코드 패치
    let fetchedRecords = try await recordRepository.fetchAllRecord()
    
    #expect(fetchedRecords == [])
  }
  
  @Test("Record Delete Error Test - Data Not Found")
  func RecordDeleteDataNotFound() async throws {
    // 1. 삭제할 레코드
    let record = DummyData.dummyRecords[0]
    
    // 2. 데이터를 삭제하지만 데이터를 못찾음
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await recordRepository.deleteRecord(record.id)
    })
  }
  
  @Test("Record Update Test")
  func updateRecord() async throws {
    // 1. 레코드 생성
    var initRecord = DummyData.dummyRecords[0]
    try await recordRepository.createRecord(initRecord)
    
    // 2. 초기 레코드 수정
    initRecord.isFavorite = true
    initRecord.state = .completed
    initRecord.starCount = 5
    
    // 3. 수정한 데이터 업데이트
    try await recordRepository.updateRecord(initRecord)
    
    // 4. 수정한 데이터 패치
    let fetchedRecord = try await recordRepository.fetchRecord(id: initRecord.id)
    
    // 5. 결과 비교
    #expect(fetchedRecord.isFavorite == true)
    #expect(fetchedRecord.state == .completed)
    #expect(fetchedRecord.starCount == 5)
  }
  
  @Test("Record Update Error Test - Data Not Found")
  func updateRecordDataNotFound() async throws {
    // 1. 수정할 레코드
    let record = DummyData.dummyRecords[0]
    
    // 2. 수정을 하지만 데이터를 못찾음
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await recordRepository.updateRecord(record)
    })
  }
}
