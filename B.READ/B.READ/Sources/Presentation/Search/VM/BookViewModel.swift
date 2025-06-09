//
//  BookViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import Foundation
import SwiftUI

final class BookViewModel: ObservableObject {
  
  enum BookState {
    case loading
    case loaded(BookDetailVO)
    case failed(Error)
  }
  
  // MARK: - State
  @Published var bookState: BookState = .loading
  @Published var selectedState: ReadingState = .notStart
  @Published var isSuccess: Bool = false
  
  var currentBook: Book?
  var isbn: String
  
  // MARK: - Intenal Property
  private var currentTask: Task<Void, Never>? = nil
  
  init(isbn: String) {
    self.isbn = isbn
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  // MARK: - Dependency
  @Dependency private var searchUseCase: SearchUseCase
  
  enum Action {
    case onAppear
    case cancelTask
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      fetchBookInfo(isbn: isbn)
    case .cancelTask:
      currentTask?.cancel()
    }
  }
}

private extension BookViewModel {
  func fetchBookInfo(isbn: String) {
    currentTask?.cancel()
    
    currentTask = Task {
      do {
        try Task.checkCancellation()
        let data = try await searchUseCase.searchBookDetail(isbn: isbn)
        let book = try await convertBookDetailToBook(data)
        try Task.checkCancellation()
        
        await MainActor.run {
          bookState = .loaded(BookDetailVO(data))
          currentBook = book
        }
      } catch {
        if Task.isCancelled {
          print("\(#function) is cancelled")
          return
        }
        
        await MainActor.run {
          bookState = .failed(error)
        }
      }
    }
  }
  
  func convertBookDetailToBook(_ detail: BookDetail) async throws -> Book {
    try Task.checkCancellation()

    guard let publishedAt = detail.publishedDate.toDate() else {
      throw NSError(domain: "InvalidDateFormat", code: 0)
    }

    let imageURL = ImageURLConverter.highQualityURL(from: detail.coverURL)
    let imageData = try await ImageConverter.convertImageURLToData(imageURL)

    try Task.checkCancellation()

    return Book(
      isbn: detail.isbn,
      coverImage: imageData,
      name: detail.title,
      author: detail.author,
      publisher: detail.publisher,
      publishedAt: publishedAt,
      totalPages: detail.pageCount
    )
  }
}
