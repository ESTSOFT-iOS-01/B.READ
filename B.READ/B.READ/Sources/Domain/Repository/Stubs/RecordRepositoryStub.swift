//
//  RecordRepositoryStub.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation

actor RecordRepositoryStub: RecordRepository {
  
  private var storedRecords: [Record] = []
  
  func createRecord(_ record: Record) throws {
    print("Stub: ", #function)
    guard storedRecords.first(where: { $0.id == record.id }) == nil else {
      throw RepositoryError.dataAlreadyExist
    }
    
    storedRecords.append(record)
  }

  func fetchAllRecord() async throws -> [Record] {
    print("Stub: ", #function)
    let records = storedRecords
    
    return records
  }

  func fetchRecentReadingRecord(count: Int) throws -> [Record] {
    print("Stub: ", #function)
    let records = storedRecords
      .filter { $0.state == .reading }
      .sorted { $0.updatedAt > $1.updatedAt }
      .prefix(count)
    
    return Array(records)
  }

  func updateRecord(_ record: Record) throws {
    print("Stub: ", #function)
    guard let recordIndex = storedRecords.firstIndex(where: { $0.id == record.id }) else {
      throw RepositoryError.dataNotFound
    }
    
    storedRecords[recordIndex] = record
  }

  func deleteRecord(_ id: String) throws {
    print("Stub: ", #function)
    guard let recordIndex = storedRecords.firstIndex(where: { $0.id == id }) else {
      throw RepositoryError.dataNotFound
    }
    
    storedRecords.remove(at: recordIndex)
  }
}
