//
//  RecordRepositoryImpl.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import SwiftData

@ModelActor
actor RecordRepositoryImpl: RecordRepository {
  func createRecord(_ record: Record) async throws {
    print("Impl: ", #function)
    
    if let _ = try findRecord(id: record.id) {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = RecordDTO(record)
    modelContext.insert(model)
  }

  func fetchAllRecord() async throws -> [Record] {
    print("Impl: ", #function)
    
    let descriptor = FetchDescriptor<RecordDTO>()
    
    do {
      let data = try modelContext.fetch(descriptor).map { $0.toEntity() }
      return data
    } catch {
      throw RepositoryError.fetchError
    }
  }

  func fetchRecentReadingRecord(count: Int) async throws -> [Record] {
    print("Impl: ", #function)
    let predicate = #Predicate<RecordDTO> { $0.state == 1 }
    let sort = SortDescriptor(\RecordDTO.updatedAt, order: .reverse)
    let descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
    
    do {
      let data = try modelContext.fetch(descriptor).prefix(count)
      return Array(data.map { $0.toEntity() })
    } catch {
      throw RepositoryError.fetchError
    }
  }

  func updateRecord(_ record: Record) async throws {
    print("Impl: ", #function)
    
    guard let data = try findRecord(id: record.id) else {
      throw RepositoryError.dataNotFound
    }
    
    // 빠진 값없이 저장해야 업데이트 반영됨
    data.isbn = record.isbn
    data.state = record.state.rawValue
    data.heartCount = record.heartCount
    data.starCount = record.starCount
    data.isFavorite = record.isFavorite
    data.startDate = record.period.startDate
    data.endDate = record.period.endDate
    data.currentPage = record.currentPage
    data.review = record.review
    data.summaryID = record.summaryID
    data.memoIDs = record.memoIDs
    data.quoteIDs = record.quoteIDs
    data.createdAt = record.createdAt
    data.updatedAt = record.updatedAt
  }

  func deleteRecord(_ id: String) async throws {
    print("Impl: ", #function)
    
    guard let data = try findRecord(id: id) else {
      throw RepositoryError.dataNotFound
    }
    
    modelContext.delete(data)
  }
}

extension RecordRepositoryImpl {
  /// 저장소에서 `RecordDTO`를 조회합니다.
  ///
  /// - Parameter id: 독서 기록의 id 정보
  /// - Returns: `RecordDTO`: 조회된 첫 번째 독서 기록  정보 DTO, 없으면 `nil`
  /// - Throws:
  ///   - `RepositoryError.fetchError`
  private func findRecord(id: String) throws -> RecordDTO? {
    let predicate = #Predicate<RecordDTO> { $0.id == id }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}
