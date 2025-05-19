//
//  LibraryViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/15/25.
//

import Foundation
import SwiftUI

// MARK: - (C)LibraryViewModel
final class LibraryViewModel: ObservableObject {
  
  // MARK: - State
  @Published var displayRecords: [Record] = []
  @Published var tabs: [TabItem] = [
    TabItem(title: "전체(0)"),
    TabItem(title: "읽은 책(0)"),
    TabItem(title: "읽는 중(0)"),
    TabItem(title: "읽을 책(0)"),
    TabItem(title: "즐겨찾기(0)")
  ]

  
  // MARK: - Internal Variable
  private var records: [Record] = [] // DB에서 가져온 전체 독서기록
  
  // MARK: - Dependency
//  @Dependency private var exampleUseCase: ExampleUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear // 뷰 등장 시
    case selectTab(index: Int) // 탭을 선택
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      fetchAllRecords() // 전체 데이터를 패치
      fetchTabs() // 패치된 데이터에서 개수를 확인
      filterRecords(index: 0) // 전체로 데이터 필터
    case .selectTab(let index):
      filterRecords(index: index) // 선택된 탭에 맞게 필터
    }
  }
}

// MARK: - (F)LibraryViewModel
extension LibraryViewModel {
  
  /// 전체 독서기록 패치 - 로컬DB에서 독서기록을 가져옴
  private func fetchAllRecords() {
    self.records = DummyData.dummyRecords.sorted {
      $0.createdAt > $1.createdAt
    }
  }
  
  /// 전체 독서기록에서 독서 기록의 개수 패치
  private func fetchTabs() {
    // 필터 조건에 맞는 독서 기록의 개수
    var count: [Int] = [records.count, 0, 0, 0, 0]
    
    for record in self.records {
      if record.isFavorite { count[4] += 1 } // 즐겨찾기 개수
      count[record.state.rawValue + 1] += 1 // 독서 상태에 따른 개수
    }
    
    // 필터에 맞는 독서기록 탭아이템
    self.tabs = [
      TabItem(title: "전체(\(count[0]))"),
      TabItem(title: "읽은 책(\(count[3]))"),
      TabItem(title: "읽는 중(\(count[2]))"),
      TabItem(title: "읽을 책(\(count[1]))"),
      TabItem(title: "즐겨찾기(\(count[4]))")
    ]
  }
  
  /// 선택된 탭에 따른 리스트에 보여줄 독서기록 필터
  private func filterRecords(index: Int) {
    switch index {
    case 1: // 읽은 책
      displayRecords = records.filter { $0.state == .completed }
    case 2: // 읽는 중
      displayRecords = records.filter { $0.state == .reading }
    case 3: // 읽을 책
      displayRecords = records.filter { $0.state == .toRead }
    case 4: // 즐겨 찾기
      displayRecords = records.filter { $0.isFavorite }
    default : // 전체
      displayRecords = records
    }
  }
  
  // TODO: - (2)displayRecords를 정렬
//  private func sortDisplayRecords() {
//    // 정렬 기준에 따라서 displayRecords를 정렬
//  }
}
