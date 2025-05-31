//
//  MemoUseCaseTest.swift
//  B.READTests
//
//  Created by 신승재 on 5/31/25.
//

import Foundation
import Testing

struct MemoUseCaseTest {

  let memoUseCase: MemoUseCase
  let bookRepository: BookRepository
  let memoRepository: MemoRepository
  
  init() {
    let storage = SwiftDataTestStorage()
    self.bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    self.memoRepository = MemoRepositoryImpl(modelContainer: storage.modelContainer)
    self.memoUseCase = MemoUseCaseImpl(
      bookRepository: BookRepositoryImpl(modelContainer: storage.modelContainer),
      memoRepository: memoRepository,
      aiService: AlanService()
    )
  }
  
  
  @Test("Memo Create & Fetch Test")
  func saveMemoTestCreate() async throws {
    try await memoUseCase.saveMemo(DummyData.memos.first!)
    
    let fetchedMemo = try await memoUseCase.fetchMemo(id: DummyData.memos.first!.id)
    #expect(fetchedMemo == DummyData.memos.first!)
  }
  
  
  @Test("Memo Update Test")
  func saveMemoTestUpdate() async throws {
    try await memoUseCase.saveMemo(DummyData.memos.first!)
    
    var updatedMemo = DummyData.memos.first!
    updatedMemo.content = "Updated Contents"
    
    try await memoUseCase.saveMemo(updatedMemo)
    
    let fetchedMemo = try await memoUseCase.fetchMemo(id: DummyData.memos.first!.id)
    #expect(fetchedMemo == updatedMemo)
  }
  
  
  @Test("Guide Generate Test")
  func generateGuideTest() async throws {
    try await bookRepository.createBook(DummyData.books.first!)
    let response = try await memoUseCase.generateGuide(isbn: DummyData.books.first!.isbn)
    print(response)
  }
  
}
