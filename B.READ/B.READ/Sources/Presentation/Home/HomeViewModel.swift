//
//  HomeViewModel.swift
//  B.READ
//
//  Created by 신승재 on 5/29/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
  
  // MARK: - State
  @Published var recentRecords: [RecordCellVO] = []
  @Published var bestSellerList: [BestSellerListVO] = []
  
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
    let bestSellerDummyData = (1...5).map {
      BestSellerVO(
        id: UUID().uuidString,
        rank: $0,
        isbn: "1234567890\($0)",
        title: "베스트셀러 \($0)",
        author: "작가 \($0)",
        imageURL: "https://image.aladin.co.kr/product/36101/66/coversum/893643974x_2.jpg"
      )
    }
    
    bestSellerList = [
      BestSellerListVO(categoryName: "인문학", bestSellers: bestSellerDummyData),
      BestSellerListVO(categoryName: "경제경영", bestSellers: bestSellerDummyData)
    ]
    
    Task { [weak self] in
      guard let self else { return }
      let records = try await libraryUseCase.loadRecentUpdatedReadingRecord(maxCount: 3)
      await MainActor.run {
        self.recentRecords = records.map { RecordCellVO(record: $0, book: $1) }
      }
    }
  }
}

