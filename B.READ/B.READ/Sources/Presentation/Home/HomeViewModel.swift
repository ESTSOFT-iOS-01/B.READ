//
//  HomeViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/29/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
  
  // MARK: - State
  @Published var recentRecords: [LibraryRecordVO] = []
  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
  @Dependency
  private var libraryUseCase: LibraryUseCase
  
  init() {
    //print("HomeViewModel 생성")
  }
  
  // MARK: - Action
  enum Action {
    case onAppear
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      fetchRecentRecords()
    }
  }
  
  deinit {
    print("HomeViewModel 소멸")
  }
}

// MARK: - Internal Function
private extension HomeViewModel {
  func fetchRecentRecords() {
    Task { [weak self] in
      guard let self else { return }
      let records = try await libraryUseCase.loadRecentUpdatedReadingRecord(maxCount: 3)
      await MainActor.run {
        self.recentRecords = records.map { record, book in
          LibraryRecordVO(
            id: record.id,
            isbn: book.isbn,
            name: book.name,
            state: record.state,
            heartCount: record.heartCount,
            starCount: record.starCount,
            percent: Int(Double(record.currentPage) / Double(book.totalPages) * 100),
            memoCount: record.memoIDs.count,
            quoteCount: record.quoteIDs.count,
            period: (record.period.startDate, record.period.endDate),
            isFavorite: record.isFavorite,
            createdAt: record.createdAt
          )
        }
      }
    }
  }
}

