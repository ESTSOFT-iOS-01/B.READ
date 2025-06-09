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
  
  @Published var selectedTabIndex: Int = 0 // 지금 보는 화면이 book인지 record인지 섹션 번호 관리
  @Published var bookLoadState: DataState = .loading
  @Published var recordLoadState: DataState = .loading
  @Published var searchKeyword: String = ""
  @Published var totalBookCount: Int = .max
  
  // MARK: - Internal Property
  private var curIndex: Int = 1
  
  // MARK: - Task Controller
  private var bookTask: Task<Void, Never>?
  private var recordTask: Task<Void, Never>?

  // MARK: - Dependency
  @Dependency private var searchUseCase: SearchUseCase
  
  deinit {
    bookTask?.cancel()
    recordTask?.cancel()
  }
  
  enum Action {
    case searchAll(String)
    case clearResult
    case searchBook(String)
    case searchRecord(String)
    case fetchMoreBooks(BookVO)
    case cancelTask
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
      
    case .cancelTask:
      bookTask?.cancel()
      recordTask?.cancel()
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
    bookTask?.cancel()
    DispatchQueue.main.async { [weak self] in
      self?.searchKeyword = keyword
    }
    
    bookTask = Task {
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
        if Task.isCancelled {
          print("\(#function) is cancelled")
          return
        }
        
        else {
          await MainActor.run {
            totalBookCount = .max
            bookLoadState = .failed(error)
            print("알라딘 서비스 검색 실패: \(error)")
            curIndex = 1
          }
        }
      }
    }
  }
  
  func loadBooksFromRepository(by keyword: String) {
    recordTask?.cancel()
    DispatchQueue.main.async { [weak self] in
      self?.searchKeyword = keyword
    }
    
    recordTask = Task {
      do {
        let repoData = try await searchUseCase.searchBooksFromRepository(query: keyword)
        let records = repoData.map { RecordCellVO(record: $0.0, book: $0.1) }
        await MainActor.run {
          recordResults = records
          recordLoadState = .loaded
        }
      } catch {
        if Task.isCancelled {
          print("\(#function) is cancelled")
          return
        }
        
        await MainActor.run {
          recordLoadState = .failed(error)
          print("로컬 검색 실패: \(error)")
        }
      }
    }
  }
  
  func searchAll(by keyword: String) {
    bookTask?.cancel()
    recordTask?.cancel()
    
    DispatchQueue.main.async { [weak self] in
      self?.searchKeyword = keyword
    }
    
    bookTask = Task { loadMoreBooksFromService(by: keyword, page: 1) }
    recordTask = Task { loadBooksFromRepository(by: keyword) }
  }
  
  func loadMoreIfNeeded(current item: BookVO) {
    guard bookResults.count < totalBookCount else { return }
    guard let lastItem = bookResults.dropLast().last else { return }
    if lastItem.id == item.id {
      send(.searchBook(searchKeyword))
    }
  }
}
