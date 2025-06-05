//
//  SearchUseCaseImpl.swift
//  B.READ
//
//  Created by 김도연 on 5/30/25.
//

import Foundation

final class SearchUseCaseImpl: SearchUseCase {
  
  private let bookRepository: BookRepository
  private let recordRepository: RecordRepository
  private let bookService: BookService
  
  init(
    bookRepository: BookRepository,
    recordRepository: RecordRepository,
    bookService: BookService
  ) {
    self.bookRepository = bookRepository
    self.recordRepository = recordRepository
    self.bookService = bookService
  }
  
  func searchBookDetail(isbn: String) async throws -> BookDetail {
    try Task.checkCancellation()
    let result = try await bookService.fetchBookDetail(isbn: isbn)
    try Task.checkCancellation()
    return result
  }

  func searchBooksFromService(query: String, page: Int) async throws -> SearchPagnation {
    try Task.checkCancellation()
    let result = try await bookService.fetchBookList(for: query, index: page)
    try Task.checkCancellation()
    return result
  }

  func searchBooksFromRepository(query: String) async throws -> [(Record, Book)] {
    try Task.checkCancellation()
    let allRecords = try await recordRepository.fetchAllRecord()
    try Task.checkCancellation()

    return try await withThrowingTaskGroup(of: (Record, Book)?.self) { group in
      for record in allRecords {
        group.addTask {
          try Task.checkCancellation()
          let book = try await self.bookRepository.fetchBook(isbn: record.isbn)
          try Task.checkCancellation()
          
          if book.name.localizedStandardContains(query) {
            return (record, book)
          } else {
            return nil
          }
        }
      }
      
      var results: [(Record, Book)] = []
      
      for try await pair in group {
        try Task.checkCancellation()
        if let pair = pair {
          results.append(pair)
        }
      }
      
      return results
    }
  }
  
}
