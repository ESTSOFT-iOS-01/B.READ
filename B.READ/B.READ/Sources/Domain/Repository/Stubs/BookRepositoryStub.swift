//
//  BookRepositoryStub.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation

actor BookRepositoryStub: BookRepository {
  
  private var storedBook: [Book] = []
//  private var storedBook: [Book] = DummyData.dummyBooks
  
  func createBook(_ book: Book) throws {
    print("Stub: ", #function)
    guard storedBook.first(where: { $0.isbn == book.isbn }) == nil else {
      throw RepositoryError.dataAlreadyExist
    }
    storedBook.append(book)
  }

  func fetchBook(isbn: String) throws -> Book {
    print("Stub: ", #function)
    guard let bookIndex = storedBook.firstIndex(where: { $0.isbn == isbn }) else {
      throw RepositoryError.dataNotFound
    }
    return storedBook[bookIndex]
  }

  func updateBook(_ book: Book) throws {
    print("Stub: ", #function)
    guard let bookIndex = storedBook.firstIndex(where: { $0.isbn == book.isbn }) else {
      throw RepositoryError.dataNotFound
    }
    storedBook[bookIndex] = book
  }
}
