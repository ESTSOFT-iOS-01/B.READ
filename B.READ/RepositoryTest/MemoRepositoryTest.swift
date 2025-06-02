//
//  MemoRepositoryTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/30/25.
//

import Foundation
import Testing

@testable import B_READ

struct MemoRepositoryTest {
  
  private let recordRepository: RecordRepository
  private let memoRepository: MemoRepository
  
  init() {
//    memoRepository = MemoRepositoryStub()
    let storage = SwiftDataTestStorage()
    self.recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    self.memoRepository = MemoRepositoryImpl(modelContainer: storage.modelContainer)
  }

  @Test("Memo Create Test")
  func createMemo() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    let dummyMemo = DummyData.dummyMemos.first!
    try await memoRepository.createMemo(dummyMemo, in: targetRecord)
    let fetchedMemo = try await memoRepository.fetchMemo(id: dummyMemo.id)
    
    // Create&Fetch 테스트
    #expect(fetchedMemo == dummyMemo)
    
    // Record에 해당하는 메모가 저장되었는지 확인
    let updatedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(updatedRecord.memos.first! == dummyMemo)
  }
  
  @Test("Memo Create Error Test - Data Already Exists")
  func createMemoInfoDataAlreadyExist() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await memoRepository.createMemo(DummyData.dummyMemos.first!, in: targetRecord)

    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
      try await memoRepository.createMemo(DummyData.dummyMemos.first!, in: targetRecord)
    })
  }

  @Test("Memo Fetch Error Test - Data Not Found")
  func fetchMemoDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await memoRepository.fetchMemo(id: "no exist id")
    })
  }
  
  @Test("Memo Fetch All Test")
  func fetchAllMemos() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    for memo in DummyData.dummyMemos {
      try await memoRepository.createMemo(memo, in: targetRecord)
    }
    
    let fetchedMemos = try await memoRepository.fetchAllMemos()
    #expect(DummyData.dummyMemos == fetchedMemos)
    
    let updatedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(updatedRecord.memos == fetchedMemos)
  }
  
  @Test("Memo Fetch All (isbn) Test")
  func fetchAllMemosIsbn() async throws {
    let dummyRecord = DummyData.dummyRecords.last! // 동일한 ISBN으로 변경
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    for memo in DummyData.dummyMemos {
      try await memoRepository.createMemo(memo, in: targetRecord)
    }
    
    let fetchedMemos = try await memoRepository.fetchAllMemos(isbn: dummyRecord.isbn)
    #expect(DummyData.dummyMemos == fetchedMemos)
    
    let updatedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(updatedRecord.memos == fetchedMemos)
  }
  
  @Test("Memo Fetch All (Contain) Test")
  func fetchAllMemosContain() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    let dummyMemos = DummyData.dummyMemos.sorted { $0.createdAt > $1.createdAt }
    
    for memo in dummyMemos {
      try await memoRepository.createMemo(memo, in: targetRecord)
    }
    
    // NOTICE: example은 모든 샘플 데이터(메모)에 포함되는 키워드 입니다~
    let fetchedMemos = try await memoRepository.fetchAllMemos(containing: "테스트")
    #expect(dummyMemos == fetchedMemos)
    
    let updatedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(updatedRecord.memos == fetchedMemos)
  }

  
  @Test("Memo All Update Test")
  func updateAllUserInfo() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await memoRepository.createMemo(DummyData.dummyMemos.first!, in: targetRecord)
    
    let updatedMemo = Memo(
      id: DummyData.dummyMemos.first!.id,
      isbn: "Updated ISBN",
      createdAt: .now,
      content: "Updated Content",
      pages: (1, 999),
      guides: [Guide(date: .now, content: "Updated Content")]
    )

    try await memoRepository.updateMemo(updatedMemo)

    let fetchedMemo = try await memoRepository.fetchMemo(id: DummyData.dummyMemos.first!.id)
    #expect(fetchedMemo == updatedMemo)
    
    let updatedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(updatedRecord.memos.first! == fetchedMemo)
  }
  
  
  @Test("Memo Update Error Test - Data Not Found")
  func updateUserInfoDataNotFound() async throws {
    let dummyMemo = Memo(
      id: DummyData.dummyMemos.first!.id,
      isbn: "ISBN",
      createdAt: .now,
      content: "Content",
      pages: (1, 999),
      guides: [Guide(date: .now, content: "Content")]
    )

    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await memoRepository.updateMemo(dummyMemo)
    })
  }

  @Test("Memo Delete Test")
  func deleteMemo() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await memoRepository.createMemo(DummyData.dummyMemos.first!, in: targetRecord)
    try await memoRepository.deleteMemo(id: DummyData.dummyMemos.first!.id)
    
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await memoRepository.fetchMemo(id: DummyData.dummyMemos.first!.id)
    })
    
    let updatedRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    #expect(updatedRecord.memos.isEmpty)
  }
  
  @Test("Memo Delete Error Test - Data Not Found")
  func deleteMemoDataNotFound() async throws {
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await memoRepository.deleteMemo(id: DummyData.dummyMemos.first!.id)
    })
  }
}


// MARK: - Entity Extensions
extension Memo: Equatable {
  static func == (lhs: Memo, rhs: Memo) -> Bool {
    return lhs.id == rhs.id &&
           lhs.isbn == rhs.isbn &&
           lhs.createdAt == rhs.createdAt &&
           lhs.content == rhs.content &&
           lhs.pages == rhs.pages &&
           lhs.guides == rhs.guides
  }
}

extension Guide: Equatable {
  static func == (lhs: Guide, rhs: Guide) -> Bool {
    return lhs.date == rhs.date &&
           lhs.content == rhs.content
  }
}
