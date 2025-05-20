//
//  QuoteRepositoryStub.swift
//  B.READ
//
//  Created by 도민준 on 5/20/25.
//

import Foundation

actor QuoteRepositoryStub: QuoteRepository {
  
  private var storedQuote: Quote?
  
  func createQuote(_ quote: Quote) throws {
    print("Stub: ", #function)
    guard storedQuote == nil else {
      throw RepositoryError.dataAlreadyExist
    }
    storedQuote = quote
  }
  
  func updateQuote(_ quote: Quote) throws {
    print("Stub: \(#function)")
    guard storedQuote != nil else {
      throw RepositoryError.dataNotFound
    }
    storedQuote = quote
  }
  
  func fetchAllQuotes() throws -> [Quote] {
    print("Stub: \(#function)")
    guard let quote = storedQuote else {
      throw RepositoryError.dataNotFound
    }
    return [quote]
  }
  
  func deleteQuote(_ quote: Quote) throws {
    print("Stub: \(#function)")
    guard storedQuote != nil else {
      throw RepositoryError.dataNotFound
    }
    storedQuote = nil
  }
}
