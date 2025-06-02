//
//  SearchViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
  // MARK: - State
  @Published var searchText: String = ""
  @Published var bestBookList: [BestSellerVO] = []
  @Published var keywordList: [String] = []
  
  @Published var bookResults: [BookVO] = []
  @Published var recordResults: [RecordCellVO] = []
  
  @Published var selectedTabIndex: Int = 0
  @Published var isSearchSubmitted: Bool = false
  @Published var isSearchFocused: Bool = false
  
  private var serviceIndex: Int = 1
  
  
  // MARK: - Dependency
  @Dependency private var searchUseCase: SearchUseCase
  @Dependency private var profileUseCase: ProfileUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onTapClear
    case onSubmitSearch
    case onTapTab(Int)
    case deleteKeyword(at: Int)
    case deleteAllKeywords
    case selectKeyword(String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadDummyData()
      
    case .onTapClear:
      searchText = ""
      isSearchSubmitted = false
      isSearchFocused = true
      
    case .onSubmitSearch:
      if !searchText.isEmpty {
        isSearchSubmitted = true
        isSearchFocused = false
        
      }
    case let .onTapTab(index):
      selectedTabIndex = index
      
    case let .deleteKeyword(index):
//      guard keywordList.indices.contains(index) else { return }
//      keywordList.remove(at: index)
      
    case .deleteAllKeywords:
//      keywordList.removeAll()
      
    case let .selectKeyword(keyword):
//      searchText = keyword
      send(.onSubmitSearch)
    }
  }
}

// MARK: - Internal Function : DUMMY DATA SETTING
private extension SearchViewModel {
  func search(by keyword: String) {
    Task {
      do {
        try await profileUseCase.addRecentKeyword(keyword)

        await loadMoreBooksFromService(by: keyword, page: 1)
        await loadBooksFromRepository(by: keyword)
      } catch {
        await MainActor.run {
          print("검색어 저장에 실패했습니다. \(error)")
        }
      }
    }
  }
  
  func loadMoreBooksFromService(by keyword: String, page: Int) async {
    do {
      let data = try await searchUseCase.searchBooksFromService(query: keyword, page: page)

      let bookDatas: [BookVO] = try await withThrowingTaskGroup(of: BookVO?.self) { group in
        for item in data.books {
          group.addTask {
            guard let imageData = try? await ImageConverter.convertImageURLToData(
              ImageURLConverter.highQualityURL(from: item.coverURL)
            ),
            let uiImage = UIImage(data: imageData),
            let date = item.publishedDate.toDate() else {
              return nil
            }

            return BookVO(
              id: UUID().uuidString,
              isbn: item.isbn,
              coverImage: Image(uiImage: uiImage),
              title: item.title,
              author: item.author,
              publisher: item.publisher,
              publishedDate: date
            )
          }
        }

        var results: [BookVO] = []
        for try await book in group {
          if let book = book {
            results.append(book)
          }
        }
        return results
      }

      await MainActor.run {
        if page == 1 {
          bookResults = bookDatas
        } else {
          bookResults.append(contentsOf: bookDatas)
        }
      }

    } catch {
      await MainActor.run {
        print("서비스 검색 실패: \(error)")
      }
    }
  }
  
  func loadBooksFromRepository(by keyword: String) async {
    do {
      let repoData = try await searchUseCase.searchBooksFromRepository(query: keyword)
      let records = repoData.map { RecordCellVO(record: $0.0, book: $0.1) }
      await MainActor.run {
        recordResults = records
      }
    } catch {
      await MainActor.run {
        print("로컬 검색 실패: \(error)")
      }
    }
  }
  
}
