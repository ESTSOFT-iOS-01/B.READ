//
//  BookRepositoryImpl.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import SwiftData

@ModelActor
actor BookRepositoryImpl: BookRepository {
  func createBook(_ book: Book) async throws {
    print("Impl: ", #function)
    
    if let _ = try findBook(isbn: book.isbn) {
      throw RepositoryError.dataAlreadyExist
    }
    
    let model = BookDTO(book)
    modelContext.insert(model)
  }

  func fetchBook(isbn: String) async throws -> Book {
    print("Impl: ", #function)
    
    guard let data = try findBook(isbn: isbn) else {
      throw RepositoryError.dataNotFound
    }
    
    return data.toEntity()
  }

  func updateBook(_ book: Book) async throws {
    print("Impl: ", #function)
    
    guard let data = try findBook(isbn: book.isbn) else {
      throw RepositoryError.dataNotFound
    }
    
    data.coverImage = book.coverImage
    data.name = book.name
    data.author = book.author
    data.publisher = book.publisher
    data.publishedAt = book.publishedAt
    data.totalPages = book.totalPages
  }
}

extension BookRepositoryImpl {
  /// 저장소에서 `BookDTO`를 조회합니다.
  ///
  /// - Parameter isbn: 도서의 ISBN 정보
  /// - Returns: `BookDTO`: 조회된 첫 번째 책 정보 DTO, 없으면 `nil`
  /// - Throws:
  ///   - `RepositoryError.fetchError`
  private func findBook(isbn: String) throws -> BookDTO? {
    let predicate = #Predicate<BookDTO> { $0.isbn == isbn }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw RepositoryError.fetchError
    }
  }
}
