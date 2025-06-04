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
  @Published var searchText: String = "" // 검색창에 입력된 검색어 내용
  @Published var bestBookList: [BestSellerVO] = [] // 기본으로 보이는 베스트셀러 리스트
  @Published var keywordList: [String] = [] // 최근 검색어 리스트 - 검색창 활성화시에만 보여짐
  
  @Published var bookResults: [BookVO] = [] // 검색어로 검색한 책 목록
  @Published var recordResults: [RecordCellVO] = [] // 검색어로 검색한 기록 목록
  
  @Published var selectedTabIndex: Int = 0 // 지금 보는 화면이 book인지 record인지 섹션 번호 관리
  @Published var isSearchSubmitted: Bool = false // 검색어가 제출되었는지 여부
  @Published var isSearchFocused: Bool = false // 검색창이 활성화되어있는지 여부
  
  private var serviceIndex: Int = 1 // 책 검색시 pagnation에서 쓰이는 인덱스
  
  
  // MARK: - Dependency
  @Dependency private var searchUseCase: SearchUseCase
  @Dependency private var profileUseCase: ProfileUseCase
  @Dependency private var recommandUseCase: RecommandUseCase
  
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
      // 초기에 베스트셀러 fetch
      loadBestSellerList()
      
    case .onTapClear:
      // x버튼 눌렀을 때, 검책창 클리어
      searchText = ""
      isSearchSubmitted = false
      isSearchFocused = true
      
    case .onSubmitSearch:
      // 검색어 입력 후 submit햇을 때
      if !searchText.isEmpty {
        isSearchSubmitted = true
        isSearchFocused = false
        search(by: searchText)
      }
    case let .onTapTab(index):
      // 섹션 탭 바꿨을 때
      selectedTabIndex = index
      
    case let .deleteKeyword(index):
      // 최근 검색어 단일 삭제
//      guard keywordList.indices.contains(index) else { return }
//      keywordList.remove(at: index)
      
    case .deleteAllKeywords:
      // 모든 최근 검색어 삭제
//      keywordList.removeAll()
      
    case let .selectKeyword(keyword):
      // 최근 검색어 골라서 바로 검색
//      searchText = keyword
      send(.onSubmitSearch)
    }
  }
}

// MARK: - Internal Function
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
  
  func loadBestSellerList() {
    Task {
      do {
        let data = try await recommandUseCase.requestBestSeller(in: 0)
        
        let list = data.map {
          BestSellerVO(
            id: UUID().uuidString,
            rank: $0.rank,
            isbn: $0.isbn,
            title: $0.title,
            author: $0.author,
            imageURL: $0.coverURL
          )
        }
        
        await MainActor.run {
          self.bestBookList = list
        }
      } catch {
        print("베스트셀러 로딩 실패: \(error)")
      }
    }
  }

  
}
