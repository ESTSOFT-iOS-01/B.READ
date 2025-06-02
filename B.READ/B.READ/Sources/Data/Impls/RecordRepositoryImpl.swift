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
  
  func createRecord(_ record: Record) throws {
    print("Impl: ", #function)
    
    if let _ = try findRecord(id: record.id) {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = RecordDTO(record)
    modelContext.insert(model)
    
    try modelContext.save()
  }
  
  func fetchRecord(id: String) throws -> Record {
    print("Impl: ", #function)
    
    guard let data = try findRecord(id: id) else {
      throw RepositoryError.dataNotFound
    }
    return data.toEntity()
  }
  
  func fetchAllRecord() throws -> [Record] {
    print("Impl: ", #function)
    
    let descriptor = FetchDescriptor<RecordDTO>()
    
    do {
      let data = try modelContext.fetch(descriptor).map { $0.toEntity() }
      return data
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
  func fetchRecentReadingRecord(maxCount: Int) throws -> [Record] {
    print("Impl: ", #function)
    
    let predicate = #Predicate<RecordDTO> { $0.state == 1 }
    let sort = SortDescriptor(\RecordDTO.updatedAt, order: .reverse)
    var descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
    descriptor.fetchLimit = maxCount
    
    do {
      let data = try modelContext.fetch(descriptor)
      return Array(data.map { $0.toEntity() })
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
  func deleteRecord(_ id: String) throws {
    print("Impl: ", #function)
    
    guard let data = try findRecord(id: id) else {
      throw RepositoryError.dataNotFound
    }
    
    modelContext.delete(data)
    
    try modelContext.save()
  }
  
  func updateRecord(_ record: Record) throws {
    print("Impl: ", #function)
    
    guard let oldValue = try findRecord(id: record.id) else {
      throw RepositoryError.dataNotFound
    }
    
    let newValue = RecordDTO(record)
    
    oldValue.state = newValue.state
    oldValue.heartCount = newValue.heartCount
    oldValue.starCount = newValue.starCount
    oldValue.isFavorite = newValue.isFavorite
    oldValue.startDate = newValue.startDate
    oldValue.endDate = newValue.endDate
    oldValue.currentPage = newValue.currentPage
    oldValue.review = newValue.review
    oldValue.updatedAt = newValue.updatedAt
    
    try modelContext.save()
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
