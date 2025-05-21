//
//  QuoteRepositoryStub.swift
//  B.READ
//
//  Created by 도민준 on 5/20/25.
//

import Foundation

actor QuoteRepositoryStub: QuoteRepository {
  private var storedQuotes: [Quote] = []

  func createQuote(_ quote: Quote) async throws {
    guard !storedQuotes.contains(where: { $0.id == quote.id }) else {
      throw RepositoryError.dataAlreadyExist
    }
    storedQuotes.append(quote)
  }

  func updateQuote(_ quote: Quote) async throws {
    guard let idx = storedQuotes.firstIndex(where: { $0.id == quote.id }) else {
      throw RepositoryError.dataNotFound
    }
    storedQuotes[idx] = quote
  }

  func deleteQuote(id: String) async throws {
    guard let idx = storedQuotes.firstIndex(where: { $0.id == id }) else {
      throw RepositoryError.dataNotFound
    }
    storedQuotes.remove(at: idx)
  }

  func fetchQuotes(isbn: String) async throws -> [Quote] {
    return storedQuotes.filter { $0.isbn == isbn }
  }

  func fetchQuote(id: String) async throws -> Quote {
    guard let quote = storedQuotes.first(where: { $0.id == id }) else {
      throw RepositoryError.dataNotFound
    }
    return quote
  }

  func fetchAllQuotes() async throws -> [Quote] {
    return storedQuotes
  }
}
