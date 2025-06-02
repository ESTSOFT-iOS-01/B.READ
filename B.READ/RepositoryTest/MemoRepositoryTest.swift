//
//  MemoRepositoryTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/30/25.
//

import Foundation
import Testing

@testable import B_READ

//struct MemoRepositoryTest {
//  
//  private let memoRepository: MemoRepository
//  
//  init() {
////    memoRepository = MemoRepositoryStub()
//    let storage = SwiftDataTestStorage()
//    memoRepository = MemoRepositoryImpl(modelContainer: storage.modelContainer)
//  }
//  
//
//  @Test("Memo Create Test")
//  func createMemo() async throws {
//    
//    try await memoRepository.createMemo(DummyData.dummyMemos.first!)
//    let fetchedMemo = try await memoRepository.fetchMemo(id: DummyData.dummyMemos.first!.id)
//    
//    #expect(fetchedMemo == DummyData.dummyMemos.first!)
//  }
//  
//  @Test("Memo Create Error Test - Data Already Exists")
//  func createMemoInfoDataAlreadyExist() async throws {
//    try await memoRepository.createMemo(DummyData.dummyMemos.first!)
//
//    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
//      try await memoRepository.createMemo(DummyData.dummyMemos.first!)
//    })
//  }
//  
//  @Test("Memo Fetch Error Test - Data Not Found")
//  func fetchMemoDataNotFound() async throws {
//    await #expect(throws: RepositoryError.dataNotFound, performing: {
//      _ = try await memoRepository.fetchMemo(id: "no exist id")
//    })
//  }
//  
//  @Test("Memo Fetch All Test")
//  func fetchAllMemos() async throws {
//    for memo in DummyData.dummyMemos {
//      try await memoRepository.createMemo(memo)
//    }
//    
//    let fetchedMemos = try await memoRepository.fetchAllMemos()
//    #expect(DummyData.dummyMemos == fetchedMemos)
//  }
//  
//  @Test("Memo Fetch All (isbn) Test")
//  func fetchAllMemosIsbn() async throws {
//    for memo in DummyData.dummyMemos {
//      try await memoRepository.createMemo(memo)
//    }
//    
//    let fetchedMemos = try await memoRepository.fetchAllMemos()
//    #expect(DummyData.dummyMemos == fetchedMemos)
//  }
//  
//  @Test("Memo Fetch All (Contain) Test")
//  func fetchAllMemosContain() async throws {
//    for memo in DummyData.dummyMemos {
//      try await memoRepository.createMemo(memo)
//    }
//    
//    // NOTICE: example은 모든 샘플 데이터(메모)에 포함되는 키워드 입니다~
//    let fetchedMemos = try await memoRepository.fetchAllMemos(containg: "example")
//    #expect(DummyData.dummyMemos == fetchedMemos)
//  }
//  
//  @Test("Memo All Update Test")
//  func updateAllUserInfo() async throws {
//    
//    try await memoRepository.createMemo(DummyData.dummyMemos.first!)
//    
//    let updatedMemo = Memo(
//      id: DummyData.dummyMemos.first!.id,
//      isbn: "Updated ISBN",
//      createdAt: .now,
//      content: "Updated Content",
//      pages: (1, 999),
//      guides: [Guide(date: .now, content: "Updated Content")]
//    )
//
//    try await memoRepository.updateMemo(updatedMemo)
//
//    let fetchedMemo = try await memoRepository.fetchMemo(id: DummyData.dummyMemos.first!.id)
//    #expect(fetchedMemo == updatedMemo)
//  }
//  
//  
//  @Test("Memo Update Error Test - Data Not Found")
//  func updateUserInfoDataNotFound() async throws {
//    let dummyMemo = Memo(
//      id: DummyData.dummyMemos.first!.id,
//      isbn: "ISBN",
//      createdAt: .now,
//      content: "Content",
//      pages: (1, 999),
//      guides: [Guide(date: .now, content: "Content")]
//    )
//
//    await #expect(throws: RepositoryError.dataNotFound, performing: {
//      try await memoRepository.updateMemo(dummyMemo)
//    })
//  }
//  
//  @Test("Memo Delete Test")
//  func deleteMemo() async throws {
//    
//    try await memoRepository.createMemo(DummyData.dummyMemos.first!)
//    try await memoRepository.deleteMemo(id: DummyData.dummyMemos.first!.id)
//    
//    await #expect(throws: RepositoryError.dataNotFound, performing: {
//      _ = try await memoRepository.fetchMemo(id: DummyData.dummyMemos.first!.id)
//    })
//  }
//  
//  @Test("Memo Delete Error Test - Data Not Found")
//  func deleteMemoDataNotFound() async throws {
//    await #expect(throws: RepositoryError.dataNotFound, performing: {
//      try await memoRepository.deleteMemo(id: DummyData.dummyMemos.first!.id)
//    })
//  }
//}
