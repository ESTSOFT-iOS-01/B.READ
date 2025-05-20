//
//  QuoteRepositoryImpl.swift
//  B.READ
//
//  Created by 도민준 on 5/20/25.
//

import Foundation
import SwiftData

@ModelActor
actor QuoteRepositoryImpl: QuoteRepository {
  func createQuote(_ quote: Quote) async throws {
    print("Impl: ", #function)
    
    if let _ = try findQuote() {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = QuoteDTO(quote)
    modelContext.insert(model)
  }

  func updateQuote(_ quote: Quote) async throws {
    print("Impl: ", #function)
    
    guard let data = try findQuote() else {
      throw RepositoryError.dataNotFound
    }
    
    data.isbn = quote.isbn
    data.content = quote.content
    data.page = quote.page
  }
  
  func fetchQuote() async throws -> Quote {
    print("Impl: ", #function)
    
    guard let data = try findQuote() else {
      throw RepositoryError.dataNotFound
    }
    
    return data.toEntity()
  }
  
  func deleteQuote(_ quote: Quote) async throws {
    print("Impl: ", #function)
    
    guard let data = try findQuote() else {
      throw RepositoryError.dataNotFound
    }
    
    modelContext.delete(data)
  }
}

extension QuoteRepositoryImpl {
  /// 저장소에서 `QuoteDTO`를 조회합니다.
  ///
  /// - Throws:
  ///   - `RepositoryError.fetchError`: 데이터를 조회하는 과정에서 에러가 발생한 경우
  ///
  /// - Returns:
  ///   - `QuoteDTO?`: 조회된 첫 번째 문장 정보 DTO, 없으면 `nil`
  private func findQuote() throws -> QuoteDTO? {
    let descriptor = FetchDescriptor<QuoteDTO>()
    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}

