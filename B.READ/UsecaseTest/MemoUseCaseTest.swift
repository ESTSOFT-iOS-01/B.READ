//
//  MemoUseCaseTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/31/25.
//

import Foundation
import Testing

@testable import B_READ

struct MemoUseCaseTest {

  let memoUseCase: MemoUseCase
  let recordRepository: RecordRepository
  let userInfoRepository: UserInfoRepository
  let bookRepository: BookRepository
  let memoRepository: MemoRepository
  
  init() {
    let storage = SwiftDataTestStorage()
    self.recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    self.userInfoRepository = UserInfoRepositoryImpl(modelContainer: storage.modelContainer)
    self.bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    self.memoRepository = MemoRepositoryImpl(modelContainer: storage.modelContainer)
    self.memoUseCase = MemoUseCaseImpl(
      userInfoRepository: userInfoRepository,
      bookRepository: BookRepositoryImpl(modelContainer: storage.modelContainer),
      memoRepository: memoRepository,
      aiService: AlanService()
    )
  }
  
  
  @Test("Memo Create & Fetch Test")
  func saveMemoTestCreate() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await memoUseCase.saveMemo(DummyData.dummyMemos.first!, in: targetRecord)
    
    let fetchedMemo = try await memoUseCase.fetchMemo(id: DummyData.dummyMemos.first!.id)
    #expect(fetchedMemo == DummyData.dummyMemos.first!)
  }
  
  
  @Test("Memo Update Test")
  func saveMemoTestUpdate() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await memoUseCase.saveMemo(DummyData.dummyMemos.first!, in: targetRecord)
    
    var updatedMemo = DummyData.dummyMemos.first!
    updatedMemo.content = "Updated Contents"
    
    try await memoUseCase.saveMemo(updatedMemo, in: targetRecord)
    
    let fetchedMemo = try await memoUseCase.fetchMemo(id: DummyData.dummyMemos.first!.id)
    #expect(fetchedMemo == updatedMemo)
  }
  
  @Test("Memo delete Test")
  func deleteMemoTestUpdate() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await memoUseCase.saveMemo(DummyData.dummyMemos.first!, in: targetRecord)
    
    try await memoUseCase.deleteMemo(id: DummyData.dummyMemos.first!.id)
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      try await memoUseCase.deleteMemo(id: DummyData.dummyMemos.first!.id)
    })
  }
  
  @Test("Guide Generate Test")
  func generateGuideTest() async throws {
    let dummyRecord = DummyData.dummyRecords.first!
    try await recordRepository.createRecord(dummyRecord)
    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
    
    try await bookRepository.createBook(DummyData.dummyBooks.first!)
    let guides = try await memoUseCase.generateGuide(isbn: DummyData.dummyBooks.first!.isbn)
    print(guides)
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
