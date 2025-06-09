//
//  SummaryUseCaseTest.swift
//  UsecaseTest
//
//  Created by 김도연 on 6/9/25.
//

import Foundation
import Testing

@testable import B_READ

final class AIServiceMock: AIService {
  func reset() async throws {
    print("Impl: ", #function)
  }

  func request(prompt: String) async throws -> String {
    return """
    {
      "Summary": "헤르만 헤세의 '싯다르타'는 주인공이 수많은 스승과 가르침을 거쳐가며, 결국 자신의 삶을 통해 진리를 깨닫는 과정을 그립니다. 싯다르타는 남의 말이 아닌 체험을 통해 지혜를 얻으며, 강을 바라보며 모든 존재가 연결되어 흐른다는 사실을 깨닫습니다. 이를 통해 나 또한 변화와 흐름을 있는 그대로 받아들이고 싶어졌습니다. 싯다르타의 삶은 고통과 실수의 연속이었지만, 그 모든 것이 깨달음으로 나아가는 길이었음을 보여줍니다. 나 역시 내 방황을 긍정하고 싶어졌습니다.",
      "feelingTags": ["깨달음", "연결", "변화", "고통", "긍정"]
    }
    """
  }
}



struct SummaryUseCaseTest {
  let summaryUseCase: SummaryUseCase
  let recordRepository: RecordRepository
  let bookRepository: BookRepository
  let summaryRepositoy: SummaryRepository
  
  init() {
    let storage = SwiftDataTestStorage()
    self.recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
    self.bookRepository = BookRepositoryImpl(modelContainer: storage.modelContainer)
    self.summaryRepositoy = SummaryRepositoryImpl(modelContainer: storage.modelContainer)
    
    self.summaryUseCase = SummaryUseCaseImpl(
      summaryRepository: summaryRepositoy,
      bookRepository: bookRepository,
      recordRepository: recordRepository,
      aiService: AIServiceMock()
    )
  }
  
  @Test("Summary Generate Success")
  func generateSummarySuccess() async throws {
    let dummyRecord = DummyData.recordForSummary
    try await recordRepository.createRecord(dummyRecord)
    try await bookRepository.createBook(DummyData.bookForSummary)
    
    let summary = try await summaryUseCase.generateSummary(in: dummyRecord)
    
    #expect(summary.isbn == dummyRecord.isbn)
    #expect(!summary.content.isEmpty)
    #expect(summary.tags.count == 5)
  }

  @Test("Summary Generate Error - Book Not Found")
  func generateSummaryBookNotFound() async throws {
    let dummyRecord = DummyData.recordForSummary
    try await recordRepository.createRecord(dummyRecord)
    
    await #expect(throws: RepositoryError.dataNotFound, performing: {
      _ = try await summaryUseCase.generateSummary(in: dummyRecord)
    })
  }
  
  @Test("Summary Generate Exact Match Test")
  func generateSummary_resultMatchesExpectedSummary() async throws {
    let dummyRecord = DummyData.recordForSummary
    try await recordRepository.createRecord(dummyRecord)
    try await bookRepository.createBook(DummyData.bookForSummary)

    let summary = try await summaryUseCase.generateSummary(in: dummyRecord)

    let expected = DummyData.summaryForRecordForSummary

    #expect(summary.isbn == expected.isbn)
    #expect(summary.content == expected.content)
    #expect(summary.tags == expected.tags)
  }

  @Test("Save Summary Then Fetch Test")
  func saveSummary_thenFetch_shouldMatch() async throws {
    let dummyRecord = DummyData.recordForSummary
    try await recordRepository.createRecord(dummyRecord)
    try await bookRepository.createBook(DummyData.bookForSummary)

    let summary = DummyData.summaryForRecordForSummary
    try await summaryUseCase.saveSummary(summary, in: dummyRecord)

    let fetched = try await summaryUseCase.fetchSummary(id: summary.id)
    #expect(fetched == summary)
  }
  
}

extension AlanSummary: Equatable {
  public static func == (lhs: AlanSummary, rhs: AlanSummary) -> Bool {
    return lhs.id == rhs.id &&
           lhs.isbn == rhs.isbn &&
           lhs.content == rhs.content &&
           lhs.tags == rhs.tags &&
           lhs.createdAt == rhs.createdAt
  }
}

extension Tag: Equatable {
  public static func == (lhs: Tag, rhs: Tag) -> Bool {
    return lhs.content == rhs.content
  }
}
