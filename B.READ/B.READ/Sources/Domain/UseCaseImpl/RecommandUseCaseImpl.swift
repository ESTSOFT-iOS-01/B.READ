//
//  RecommandUseCaseImpl.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import Foundation

final class RecommandUseCaseImpl: RecommandUseCase {
  private let bookService: BookService
  
  init(bookService: BookService) {
    self.bookService = bookService
  }
  
  func requestBestSeller(in category: Int = 0) async throws -> [BestSeller] {
    return try await bookService.fetchBestSeller(in: category)
  }
  
}
