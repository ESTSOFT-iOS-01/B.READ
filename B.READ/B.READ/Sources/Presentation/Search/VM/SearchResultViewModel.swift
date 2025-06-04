//
//  SearchResultViewModel.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import Foundation
import SwiftUI

final class SearchResultViewModel: ObservableObject {
  // MARK: - State
  @Published var bookResults: [BookVO] = [] // 검색어로 검색한 책 목록
  @Published var recordResults: [RecordCellVO] = [] // 검색어로 검색한 기록 목록
  
  // 호출 중 상태 관리 변수 2개
  @Published var selectedTabIndex: Int = 0 // 지금 보는 화면이 book인지 record인지 섹션 번호 관리 -> 이거 뷰에서 바로 하나?
  
  private var serviceIndex: Int = 1
  
  // MARK: - Dependency
  @Dependency private var searchUseCase: SearchUseCase
  
  enum Action {
    case onAppear(String)
    case clearResult
    case searchBook(String)
    case searchRecord(String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear(let keyword):
      searchAll(by: keyword)
    case .clearResult:
      serviceIndex = 1
    case .searchBook(let keyword):
      loadMoreBooksFromService(by: keyword, page: serviceIndex)
    case .searchRecord(let keyword):
      loadBooksFromRepository(by: keyword)
    }
  }
  
  func loadMoreBooksFromService(by keyword: String, page: Int) {
    Task {
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
            serviceIndex += 1
          } else {
            bookResults.append(contentsOf: bookDatas)
            serviceIndex += 1
          }
        }

      } catch {
        await MainActor.run {
          print("서비스 검색 실패: \(error)")
          serviceIndex = 1
        }
      }
    }
  }
  
  func loadBooksFromRepository(by keyword: String) {
    Task {
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
  
  func searchAll(by keyword: String) {
    Task {
      await withTaskGroup(of: Void.self) { group in
        group.addTask { self.loadBooksFromRepository(by: keyword) }
        group.addTask { self.loadMoreBooksFromService(by: keyword, page: 1) }
      }
    }
  }
  
}
