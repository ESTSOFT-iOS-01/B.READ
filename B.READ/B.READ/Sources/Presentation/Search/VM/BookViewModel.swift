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
  
  var isbn: String
  
  @Published var bookState: BookState = .loading
  @Published var selectedState: ReadingState = .notStart

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
          bookState = .loaded(
            BookDetailVO(
              id: UUID().uuidString,
              title: data.title,
              author: data.author,
              publishedDate: data.publishedDate,
              description: data.description,
              isbn: data.isbn,
              coverURL: data.coverURL,
              publisher: data.publisher,
              pageCount: data.pageCount,
              ratingScore: data.ratingScore,
              ratingCount: data.ratingCount,
              link: data.link
            )
          )
        }
      } catch {
        await MainActor.run {
          bookState = .failed(error)
        }
      }
    }
  }
}

struct ImageURLConverter {
  /// 썸네일(coversum)을 고화질(cover500)로 변환
  static func highQualityURL(from originalURL: String) -> String {
    originalURL.replacingOccurrences(of: "/coversum/", with: "/cover500/")
  }
}
