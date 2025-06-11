////
////  SummaryRepositoryTest.swift
////  RepositoryTest
////
////  Created by 김도연 on 6/9/25.
////
//
//import Foundation
//import Testing
//
//@testable import B_READ
//
//struct SummaryRepositoryTest {
//  
//  private let recordRepository: RecordRepository
//  private let summaryRepository: SummaryRepository
//  
//  init() {
//    let storage = SwiftDataTestStorage()
//    self.recordRepository = RecordRepositoryImpl(modelContainer: storage.modelContainer)
//    self.summaryRepository = SummaryRepositoryImpl(modelContainer: storage.modelContainer)
//  }
//  
//  @Test("Summary Create Test")
//  func createSummary() async throws {
//    // Given
//    let dummyRecord = DummyData.dummyRecords.first!
//    try await recordRepository.createRecord(dummyRecord)
//    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
//    let dummySummary = DummyData.summary1
//    
//    // When
//    try await summaryRepository.createSummary(dummySummary, in: targetRecord)
//    let fetchedSummary = try await summaryRepository.fetchSummary(id: dummySummary.id)
//    
//    // Then
//    #expect(fetchedSummary.id == dummySummary.id)
//    #expect(fetchedSummary.tags.count == dummySummary.tags.count)
//  }
//  
//  @Test("Summary Create Error Test - Data Already Exists")
//  func createSummaryDataAlreadyExists() async throws {
//    // Given
//    let dummyRecord = DummyData.dummyRecords.first!
//    try await recordRepository.createRecord(dummyRecord)
//    let targetRecord = try await recordRepository.fetchRecord(id: dummyRecord.id)
//    let dummySummary = DummyData.summary1
//    try await summaryRepository.createSummary(dummySummary, in: targetRecord)
//    
//    // When + Then
//    await #expect(throws: RepositoryError.dataAlreadyExist, performing: {
//      try await summaryRepository.createSummary(dummySummary, in: targetRecord)
//    })
//  }
//  
//  @Test("Summary Fetch Error Test - Data Not Found")
//  func fetchSummaryDataNotFound() async throws {
//    // When + Then
//    await #expect(throws: RepositoryError.dataNotFound, performing: {
//      _ = try await summaryRepository.fetchSummary(id: "non-existent-id")
//    })
//  }
//  
//  @Test("Summary Fetch All Test")
//  func fetchAllSummaries() async throws {
//    // Given
//    for record in DummyData.dummyRecords {
//      try await recordRepository.createRecord(record)
//    }
//
//    for i in 0..<DummyData.dummySummaries.count {
//      let targetRecord = try await recordRepository.fetchRecord(id: DummyData.dummyRecords[i].id)
//      try await summaryRepository.createSummary(DummyData.dummySummaries[i], in: targetRecord)
//    }
//
//    // When
//    let fetchedSummaries = try await summaryRepository.fetchAllSummary()
//    
//    // Then
//    let expectedSummaries = DummyData.dummySummaries.sorted { $0.createdAt > $1.createdAt }
//    let actualSummaries = fetchedSummaries.sorted { $0.createdAt > $1.createdAt }
//    #expect(expectedSummaries.first?.id == actualSummaries.first?.id)
//    #expect(expectedSummaries.count == actualSummaries.count)
//  }
//  
//}
//
//// MARK: - Entity Extensions
//extension AlanSummary: Equatable {
//  public static func == (lhs: AlanSummary, rhs: AlanSummary) -> Bool {
//    return lhs.id == rhs.id &&
//           lhs.isbn == rhs.isbn &&
//           lhs.content == rhs.content &&
//           lhs.tags == rhs.tags &&
//           lhs.createdAt == rhs.createdAt
//  }
//}
//
//extension Tag: Equatable {
//  public static func == (lhs: Tag, rhs: Tag) -> Bool {
//    return lhs.id == rhs.id &&
//           lhs.content == rhs.content
//  }
//}
