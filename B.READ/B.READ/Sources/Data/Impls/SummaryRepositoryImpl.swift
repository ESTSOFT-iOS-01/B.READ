//
//  SummaryRepositoryImpl.swift
//  B.READ
//
//  Created by 김도연 on 6/9/25.
//

import Foundation
import SwiftData

@ModelActor
actor SummaryRepositoryImpl: SummaryRepository {
  
  func createSummary(_ summary: AlanSummary, in record: Record) async throws {
    print("Impl: ", #function)
    
    if let _ = try findSummary(id: summary.id) {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = SummaryDTO(summary, record: RecordDTO(record))
    modelContext.insert(model)
    
    try modelContext.save()
  }
  
  func fetchSummary(id: String) async throws -> AlanSummary {
    print("Impl: ", #function)
    
    guard let data = try findSummary(id: id) else {
      throw RepositoryError.dataNotFound
    }
    
    return data.toEntity()
  }
  
  func fetchAllSummary() async throws -> [AlanSummary] {
    print("Impl: ", #function)
    
    let descriptor = FetchDescriptor<SummaryDTO>()
    
    do {
      let data = try modelContext.fetch(descriptor)
      return data.map { $0.toEntity() }
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
}

private extension SummaryRepositoryImpl {
  func findSummary(id: String) throws -> SummaryDTO? {
    let predicate = #Predicate<SummaryDTO> { $0.id == id }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}
