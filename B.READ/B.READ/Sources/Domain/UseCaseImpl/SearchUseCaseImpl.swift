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
    return try await bookService.fetchBookDetail(isbn: isbn)
  }

  func searchBooksFromService(query: String, page: Int) async throws -> SearchPagnation {
    return try await bookService.fetchBookList(for: query, index: page)
  }

  func searchBooksFromRepository(query: String) async throws -> [(Record, Book)] {
    let allRecords = try await recordRepository.fetchAllRecord()

    return try await withThrowingTaskGroup(of: (Record, Book)?.self) { group in
      for record in allRecords {
        group.addTask {
          let book = try await self.bookRepository.fetchBook(isbn: record.isbn)
          
          if book.name.localizedStandardContains(query) {
            return (record, book)
          } else {
            return nil
          }
        }
      }
      
      var results: [(Record, Book)] = []
      
      for try await pair in group {
        if let pair = pair {
          results.append(pair)
        }
      }
      
      return results
    }
  }
  
}
