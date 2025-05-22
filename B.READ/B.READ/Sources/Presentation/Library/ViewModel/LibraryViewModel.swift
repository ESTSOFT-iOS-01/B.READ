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
  struct LibraryViewState {
    var tabs: [TabItem] = [
      TabItem(title: "전체(0)"),
      TabItem(title: "읽은 책(0)"),
      TabItem(title: "읽는 중(0)"),
      TabItem(title: "읽을 책(0)"),
      TabItem(title: "즐겨찾기(0)")
    ]
    var displayRecords: [LibraryRecordVO] = []
    var selectedTab: Int = 0
  }
  @Published var state: LibraryViewState = .init()
  
  // MARK: - Internal Variable
  private var records: [LibraryRecordVO] = [] // DB에서 가져온 전체 독서기록
  
  // TODO: - 유스케이스로 빠질 예정
  private let bookRepo: BookRepository = BookRepositoryStub()
  private let recordRepo: RecordRepository = RecordRepositoryStub()
  
  
  // MARK: - Dependency
//  @Dependency private var exampleUseCase: ExampleUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear // 뷰 등장 시
    case selectTab // 탭을 선택
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        await loadRecords()
        await MainActor.run {
          loadTabs()
          filterRecords()
          sortDisplayRecords()
        }
      }
    case .selectTab:
      return
    }
  }
}

// MARK: - (F)LibraryViewModel
// TODO: - Error 상황에 따른 옳은 행동 추가
private extension LibraryViewModel {
  
  /// 독서 기록 정보를 불러옴
  func loadRecords() async {
    do {
      let infos: [LibraryCellInfo] = try await self.fetchRecordCellInfo()
      self.records = infos.map {
        // TODO: - totalPages -> totalPage 변수명 변경
        // TODO: - coverImageData -> coverImage 필요(강제 언래핑X)
        LibraryRecordVO(
          id: $0.record.id,
          isbn: $0.record.isbn,
          name: $0.book.name,
          coverImage: $0.book.coverImage,
          state: $0.record.state,
          heartCount: $0.record.heartCount,
          starCount: $0.record.starCount,
          percent: Int(Double($0.record.currentPage) / Double($0.book.totalPages) * 100),
          memoCount: $0.record.memoIDs.count,
          quoteCount: $0.record.quoteIDs.count,
          period: ($0.record.period.startDate, $0.record.period.endDate),
          isFavorite: $0.record.isFavorite,
          createdAt: $0.record.createdAt
        )
      }
    } catch {
      self.records = []
    }
  }
  
  /// 탭에 해당하는 독서 기록 개수를 불러옴 - 독서 기록에 종속해서 변하기 때문에 ViewModel에서 처리
  func loadTabs() {
    var count: [Int] = [records.count, 0, 0, 0, 0]
    
    for record in self.records {
      if record.isFavorite { count[4] += 1 } // 즐겨찾기 개수
      count[record.state.rawValue + 1] += 1 // 독서 상태에 따른 개수
    }
    
    self.state.tabs = [
      TabItem(title: "전체(\(count[0]))"),
      TabItem(title: "읽은 책(\(count[3]))"),
      TabItem(title: "읽는 중(\(count[2]))"),
      TabItem(title: "읽을 책(\(count[1]))"),
      TabItem(title: "즐겨찾기(\(count[4]))")
    ]
  }
  
  /// 선택된 탭에 따른 리스트에 보여줄 독서기록 필터
  func filterRecords() {
    switch state.selectedTab {
    case 1: // 읽은 책
      state.displayRecords = records.filter { $0.state == .completed }
    case 2: // 읽는 중
      state.displayRecords = records.filter { $0.state == .reading }
    case 3: // 읽을 책
      state.displayRecords = records.filter { $0.state == .toRead }
    case 4: // 즐겨 찾기
      state.displayRecords = records.filter { $0.isFavorite }
    default : // 전체
      state.displayRecords = records
    }
  }
  
  // TODO: - (2)displayRecords를 정렬 내용 추가
  private func sortDisplayRecords(by: SortState = .recent) {
    // 정렬 기준에 따라서 displayRecords를 정렬
    switch by {
    case .recent:
      state.displayRecords = state.displayRecords.sorted { $0.createdAt > $1.createdAt }
    case .older:
      state.displayRecords = state.displayRecords.sorted { $0.createdAt < $1.createdAt }
    }
  }
}


// MARK: - (F)LibraryViewModel
// TODO: - 유스케이스로 빠질 함수들
private extension LibraryViewModel {
  
  /// 독서 기록 셀에서 필요한 정보를 가져옴
  func fetchRecordCellInfo() async throws -> [LibraryCellInfo] {
    var cellInfos: [LibraryCellInfo] = []
    
    // 1. 독서 기록 정보 패치
    let records = try await recordRepo.fetchAllRecord()
    
    // 2. 독서 기록에 대한 도서 정보 패치
    for record in records {
      let book = try await bookRepo.fetchBook(isbn: record.isbn)
      // 정보를 infos에 저장
      cellInfos.append((book, record))
    }
    return cellInfos
  }
}
