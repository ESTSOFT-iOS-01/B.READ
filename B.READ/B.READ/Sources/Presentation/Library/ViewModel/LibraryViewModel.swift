//
//  LibraryViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/15/25.
//

import Foundation
import SwiftUI

final class LibraryViewModel: ObservableObject {
  
  // MARK: - State
  @Published var records: [Record] = []
  @Published var tabs: [TabItem] = []

  
  // MARK: - Internal Variable
  private var example: String?
  
  // MARK: - Dependency
//  @Dependency private var exampleUseCase: ExampleUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case fetchTabs
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      fetchRecords()
      fetchTabs()
    case .fetchTabs:
      fetchTabs()
    }
  }
}

extension LibraryViewModel {
  
  // 상단 탭의 독서기록 개수 패치
  private func fetchTabs() {
    // 필터 조건에 맞는 독서 기록의 개수
    var count: [Int] = [records.count, 0, 0, 0, 0]
    
    for record in self.records {
      if record.isFavorite { count[4] += 1 } // 즐겨찾기 개수
      count[record.state.rawValue + 1] += 1 // 독서 상태에 따른 개수
    }
    // 필터에 맞는 독서 기록 탭아이템
    self.tabs = [
      TabItem(title: "전체(\(count[0]))"),
      TabItem(title: "읽은 책(\(count[1]))"),
      TabItem(title: "읽는 중(\(count[2]))"),
      TabItem(title: "읽을 책(\(count[3]))"),
      TabItem(title: "즐겨찾기(\(count[4]))")
    ]
  }
  
  // 독서기록 패치
  private func fetchRecords() {
    self.records = dummyRecords.sorted {
      $0.createdAt > $1.createdAt
    }
  }
}
