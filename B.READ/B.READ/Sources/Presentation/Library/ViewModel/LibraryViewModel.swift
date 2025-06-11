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
  
  enum ViewState {
    case loading
    case loaded
  }
  
  // MARK: - State
  @Published var tabs: [TabItem] = [
    TabItem(title: "전체(0)"),
    TabItem(title: "읽은 책(0)"),
    TabItem(title: "읽는 중(0)"),
    TabItem(title: "읽을 책(0)"),
    TabItem(title: "즐겨찾기(0)")
  ]
  // 선택된 탭
  @Published var selectedTab: Int = 0
  // 탭별 정렬 기준
  @Published var selectedSort: [SortOption] = [.recent, .recent, .recent, .recent, .recent]
  // 뷰로 보여주는 독서 기록
  @Published var displayRecords: [RecordCellVO] = []
  @Published var viewState: ViewState = .loading
  
  // MARK: - Internal Variable
  // DB에서 가져온 전체 독서기록
  private var records: [RecordCellVO] = []
  private var filteredRecords: [RecordCellVO] = []
  private var currentTask: Task<Void, Never>? = nil
  
  // MARK: - Dependency
  @Dependency
  private var libraryUseCase: LibraryUseCase
  
  
  // MARK: - Action
  enum Action {
    case onAppear // 뷰 등장 시
    case selectTab // 탭을 선택 시
    case selectSort // 정렬을 선택 시
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      self.loadRecords()
      
    case .selectTab:
      self.selectTab()
      
    case .selectSort:
      self.selectSort()
    }
  }
}


// MARK: - (F)LibraryViewModel - 액션 함수
private extension LibraryViewModel {
  // 독서 기록을 불러옴
  func loadRecords() {
    viewState = .loading
    
    currentTask?.cancel()
    
    currentTask = Task {
      try? Task.checkCancellation()
      await fetchRecords()
      
      await withTaskGroup(of: Void.self) { group in
        group.addTask {
          // 2. 불러온 독서 기록의 상태별 개수 확인
          await self.loadTabs()
        }
        
        group.addTask {
          // 3. 선택된 탭을 기준으로 필터 적용
          await self.filterRecords()
          // 4. 필터 적용된 독서 기록에 정렬 적용
          await self.sortDisplayRecords(by: self.selectedSort[self.selectedTab])
        }
      }
      
      await MainActor.run {
        viewState = .loaded
      }
    }
  }
  
  // 상단 탭바를 선택
  func selectTab() {
    currentTask?.cancel()
    
    currentTask = Task {
      try? Task.checkCancellation()
      // 1. 선택된 탭을 기준으로 필터 적용
      await self.filterRecords()
      // 2. 필터 적용된 독서 기록에 정렬 적용
      await self.sortDisplayRecords(by: self.selectedSort[self.selectedTab])
    }
  }
  
  // 정렬을 선택
  func selectSort() {
    currentTask?.cancel()
    
    currentTask = Task {
      try? Task.checkCancellation()
      await self.sortDisplayRecords(by: self.selectedSort[self.selectedTab])
    }
  }
}


// MARK: - (F)LibraryViewModel - 내부 함수(async)
private extension LibraryViewModel {
  /// 독서 기록 정보를 불러옴
  func fetchRecords() async {
    do {
      // 1. 독서 기록 패치
      let infos: [(record: Record, book: Book)] = try await libraryUseCase.loadRecordList()
      // 2. Entity -> VO
      self.records = infos.map { RecordCellVO(record: $0.record, book: $0.book) }
    } catch {
      // 3. 패치하던중 오류 발생 시 배열은 빈 배열을 반환
      print(error.localizedDescription)
      self.records = []
    }
  }
  
  /// 탭에 해당하는 독서 기록 개수를 불러옴
  func loadTabs() async {
    // 1. 탭의 기본값
    var count: [Int] = [records.count, 0, 0, 0, 0]
    
    // 2. 각 탭에 해당하는 독서 기록의 개수측정
    for record in self.records {
      if record.isFavorite { count[4] += 1 } // 즐겨찾기 개수
      count[record.readingState.rawValue + 1] += 1 // 독서 상태에 따른 개수
    }
    
    // 3. 탭 생성
    let tabs = [
      TabItem(title: "전체(\(count[0]))"),
      TabItem(title: "읽은 책(\(count[3]))"),
      TabItem(title: "읽는 중(\(count[2]))"),
      TabItem(title: "읽을 책(\(count[1]))"),
      TabItem(title: "즐겨찾기(\(count[4]))")
    ]
    
    // 4. 뷰 업데이트
    await MainActor.run {
      self.tabs = tabs
    }
  }
  
  /// 선택된 탭에 따른 리스트에 보여줄 독서 기록 필터
  func filterRecords() async {
    // 1. 필터를 씌운 결과
    let filterRecord: [RecordCellVO]
    
    // 2. 전체 독서 기록에 필터 적용
    switch selectedTab {
    case 1: // 읽은 책
      filterRecord = records.filter { $0.readingState == .finished }
    case 2: // 읽는 중
      filterRecord = records.filter { $0.readingState == .reading }
    case 3: // 읽을 책
      filterRecord = records.filter { $0.readingState == .notStart }
    case 4: // 즐겨 찾기
      filterRecord = records.filter { $0.isFavorite }
    default : // 전체
      filterRecord = records
    }
    
    // 3. 필터 적용한 독서 기록을 뷰에 반영
    await MainActor.run {
      self.filteredRecords = filterRecord
    }
  }
  
  /// 정렬 기준에 따라서 displayRecords를 정렬
  func sortDisplayRecords(by: SortOption = .recent) async {
    // 1. 정렬한 결과
    let sortedRecords: [RecordCellVO] = filteredRecords.sorted(by: by.sort)
    
    // 2. 결과를 뷰에 반영
    await MainActor.run {
      self.displayRecords = sortedRecords
    }
  }
}
