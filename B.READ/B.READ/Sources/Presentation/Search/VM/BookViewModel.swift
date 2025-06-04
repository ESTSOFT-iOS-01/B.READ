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
  
  @Published var bookState: BookState = .loading
  @Published var selectedState: ReadingState = .notStart
  
  var isbn: String
  
  init(isbn: String) {
    self.isbn = isbn
  }
  
  @Dependency
private var searchUseCase: SearchUseCase
  
  enum Action {
    case onAppear
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      fetchBookInfo(isbn: isbn)
    }
  }
}

private extension BookViewModel {
  func fetchBookInfo(isbn: String) {
    Task {
      do {
        let data = try await searchUseCase.searchBookDetail(isbn: isbn)
        
        await MainActor.run {
          bookState = .loaded(BookDetailVO(data))
        }
      } catch {
        await MainActor.run {
          bookState = .failed(error)
        }
      }
    }
  }
}
