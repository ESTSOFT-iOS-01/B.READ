//
//  SearchResultViewModel.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import Foundation
import SwiftUI

final class SearchResultViewModel: ObservableObject {
  
  enum DataState {
    case loading
    case loaded
    case failed(Error)
  }
  
  // MARK: - State
  @Published var bookResults: [BookVO] = [] // 검색어로 검색한 책 목록
  @Published var recordResults: [RecordCellVO] = [] // 검색어로 검색한 기록 목록
  
  @Published var selectedTabIndex: Int = 0 // 지금 보는 화면이 book인지 record인지 섹션 번호 관리 -> 이거 뷰에서 바로 하나?
  @Published var bookLoadState: DataState = .loading
  @Published var recordLoadState: DataState = .loading
  
  private var curIndex: Int = 1
  @Published var searchKeyword: String = ""
  
  private var totalBookCount: Int = .max
  internal var currentTask: Task<Void, Never>? = nil
  
  // MARK: - Dependency
  @Dependency private var searchUseCase: SearchUseCase
  
  enum Action {
    case searchAll(String)
    case clearResult
    case searchBook(String)
    case searchRecord(String)
    case fetchMoreBooks(BookVO)
  }
  
  func send(_ action: Action) {
    switch action {
    case .searchAll(let keyword):
      searchAll(by: keyword)
    case .clearResult:
      reset()
    case .searchBook(let keyword):
      loadMoreBooksFromService(by: keyword, page: curIndex)
    case .searchRecord(let keyword):
      loadBooksFromRepository(by: keyword)
    case .fetchMoreBooks(let data):
      loadMoreIfNeeded(current: data)
    }
  }
  
}

private extension SearchResultViewModel {
  func reset() {
    bookResults = []
    recordResults = []
    bookLoadState = .loading
    recordLoadState = .loading
    curIndex = 1
    searchKeyword = ""
    totalBookCount = .max
  }
  
  func loadMoreBooksFromService(by keyword: String, page: Int) {
    DispatchQueue.main.async { [weak self] in
      self?.searchKeyword = keyword
    }
    currentTask?.cancel()
    
    currentTask = Task {
      do {
        try Task.checkCancellation()
        let data = try await searchUseCase.searchBooksFromService(query: keyword, page: page)
        try Task.checkCancellation()
        
        let bookDatas: [BookVO] = try await withThrowingTaskGroup(of: BookVO?.self) { group in
          for item in data.books {
            group.addTask {
              try Task.checkCancellation()
              guard let imageData = try? await ImageConverter.convertImageURLToData(
                ImageURLConverter.highQualityURL(from: item.coverURL)
              ),
                    let uiImage = UIImage(data: imageData),
                    let date = item.publishedDate.toDate() else {
                return nil
              }
              
              return BookVO(book: item, image: Image(uiImage: uiImage), pubDate: date)
            }
          }
          
          var results: [BookVO] = []
          for try await book in group {
            try Task.checkCancellation()
            if let book = book {
              results.append(book)
            }
          }
          return results
        }
        
        await MainActor.run {
          totalBookCount = data.totalCount
          if page == 1 {
            bookResults = bookDatas
            curIndex += 1
          } else {
            bookResults.append(contentsOf: bookDatas)
            curIndex += 1
          }
          bookLoadState = .loaded
        }
        
      } catch {
        if Task.isCancelled { return }
        await MainActor.run {
          totalBookCount = .max
          bookLoadState = .failed(error)
          print("알라딘 서비스 검색 실패: \(error)")
          curIndex = 1
        }
      }
    }
  }
  
  func loadBooksFromRepository(by keyword: String) {
    DispatchQueue.main.async { [weak self] in
      self?.searchKeyword = keyword
    }
    
    Task {
      do {
        let repoData = try await searchUseCase.searchBooksFromRepository(query: keyword)
        let records = repoData.map { RecordCellVO(record: $0.0, book: $0.1) }
        await MainActor.run {
          recordResults = records
          recordLoadState = .loaded
        }
      } catch {
        await MainActor.run {
          recordLoadState = .failed(error)
          print("로컬 검색 실패: \(error)")
        }
      }
    }
  }
  
  func searchAll(by keyword: String) {
    currentTask?.cancel()
    DispatchQueue.main.async { [weak self] in
      self?.searchKeyword = keyword
    }
    
    currentTask = Task {
      await withTaskGroup(of: Void.self) { group in
        group.addTask { self.loadBooksFromRepository(by: keyword) }
        group.addTask { self.loadMoreBooksFromService(by: keyword, page: 1) }
      }
    }
  }
  
  func loadMoreIfNeeded(current item: BookVO) {
    guard bookResults.count < totalBookCount else { return }
    guard let lastItem = bookResults.dropLast().last else { return }
    if lastItem.id == item.id {
      send(.searchBook(searchKeyword))
    }
  }
}
