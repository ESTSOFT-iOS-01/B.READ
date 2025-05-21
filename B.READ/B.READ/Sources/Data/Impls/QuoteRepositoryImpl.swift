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
      print("Impl: \(#function)")
      if let _ = try findQuote(id: quote.id) {
        throw RepositoryError.dataAlreadyExist
      }
      let dto = QuoteDTO(quote)
      modelContext.insert(dto)
    }

  func updateQuote(_ quote: Quote) async throws {
      print("Impl: \(#function)")
      guard let dto = try findQuote(id: quote.id) else {
        throw RepositoryError.dataNotFound
      }
      dto.isbn = quote.isbn
      dto.content = quote.content
      dto.page = quote.page
    }

  func deleteQuote(id: String) async throws {
    print("Impl: \(#function)")
    guard let dto = try findQuote(id: id) else {
      throw RepositoryError.dataNotFound
    }
    modelContext.delete(dto)
  }
  
  func fetchQuotes(isbn: String) async throws -> [Quote] {
    print("Impl: \(#function)")
    do {
      let descriptor = FetchDescriptor<QuoteDTO>(
        predicate: #Predicate { $0.isbn == isbn },
        sortBy: [.init(\.page, order: .forward)]
      )
      let dtos = try modelContext.fetch(descriptor)
      return dtos.map { $0.toEntity() }
    } catch {
      throw RepositoryError.fetchError
    }
  }
  
  func fetchQuote(id: String) async throws -> Quote {
     print("Impl: \(#function)")
     guard let dto = try findQuote(id: id) else {
       throw RepositoryError.dataNotFound
     }
     return dto.toEntity()
   }
  
  func fetchAllQuotes() async throws -> [Quote] {
    print("Impl: \(#function)")
    do {
      let descriptor = FetchDescriptor<QuoteDTO>(
        sortBy: [.init(\.page, order: .forward)]
      )
      let dtos = try modelContext.fetch(descriptor)
      return dtos.map { $0.toEntity() }
    } catch {
      throw RepositoryError.fetchError
    }
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
  private func findQuote(id: String) throws -> QuoteDTO? {
    do {
      let descriptor = FetchDescriptor<QuoteDTO>(predicate: #Predicate { $0.id == id })
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}

