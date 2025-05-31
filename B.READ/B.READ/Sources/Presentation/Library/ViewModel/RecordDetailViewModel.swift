//
//  RecordViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/19/25.
//

import Foundation
import SwiftUI

// TODO: - (db연결 후) Book 테이블에서 isbn에 맞는 책 이미지를 가져와서 보여줘야함
// MARK: - (C)RecordDetailVieModel
final class RecordDetailViewModel: ObservableObject {
  
  // MARK: - State
  struct RecordDetailState {
    var info: (record: Record, book: Book)? = nil
    var memos: [Memo] = []
    var quotes: [Quote] = []
    var selectedTab: Int = 0
    var selectedQuote: Quote? = nil
  }
  
  @Published var state: RecordDetailState = .init()
  
  // MARK: - Internal Variable
  let recordID: String
  let isbn: String
  
  init(recordID: String, isbn: String) {
    self.recordID = recordID
    self.isbn = isbn
  }
  
  // TODO: - 유스케이스로 빠질 예정
  private let bookRepo: BookRepository = BookRepositoryStub()
  private let recordRepo: RecordRepositoryStub = RecordRepositoryStub()
  
  // MARK: - Dependency
  //  @Dependency private var exampleUseCase: ExampleUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onTapFavorite
    case onTapDelete
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task {
        await loadInfo(id: recordID, isbn: isbn)
        await loadMemos()
        await loadQuote()
      }
    case .onTapFavorite:
      Task {
        await toggleIsFavorite()
      }
    case .onTapDelete:
      Task {
        await deleteRecord()
      }
    }
  }
}


// MARK: - (F)LibraryViewModel
// TODO: - Error 상황에 따른 옳은 행동 추가
private extension RecordDetailViewModel {
  
  /// 독서 기록 조회에서 필요한 정보를 불러옴
  @MainActor
  func loadInfo(id: String, isbn: String) async {
    do {
      let info: (Record, Book) = try await self.fetchRecordInfo(id: recordID, isbn: isbn)
      self.state.info = info
    } catch {
      print(error.localizedDescription)
    }
  }
  
  /// 즐겨 찾기 정보를 업데이트
  func toggleIsFavorite() async {
    await MainActor.run {
      // 즐겨찾기 정보를 토글
      self.state.info?.record.isFavorite.toggle()
    }
    // record 정보가 있는지 확인
    guard let record = self.state.info?.record else {
      print("ViewModelError.dataNotFound")
      return
    }
    // 확인한 정보를 업데이트
    do {
      try await self.updateRecordInfo(record: record)
    } catch {
      print(RepositoryError.dataNotFound.errorDescription!)
      // 업데이트를 하는데 정보가 없다? -> 새로 생성
    }
  }
  
  /// 독서 기록을 삭제
  func deleteRecord() async {
    guard let record = self.state.info?.record else {
      print("ViewModelError.dataNotFound")
      return
    }
    // 확인한 정보를 삭제
    do {
      try await self.deleteRecordInfo(id: record.id)
    } catch {
      
    }
  }
  
  @MainActor
  func loadMemos() {
    self.state.memos = DummyData.dummyMemos.filter {
      if let info = state.info { return info.record.memoIDs.contains($0.id) }
      return false
    }
  }
  
  @MainActor
  func loadQuote() {
    self.state.quotes = DummyData.dummyQuote.filter {
      if let info = state.info { return info.record.memoIDs.contains($0.id) }
      return false
    }
  }
}

// MARK: - (F)LibraryViewModel
// TODO: - 유스케이스로 빠질 함수들
private extension RecordDetailViewModel {
  
  /// 독서 기록 조회에서 필요한 정보(책, 독서 기록)를 가져옴
  func fetchRecordInfo(id: String, isbn: String) async throws -> (Record, Book) {
    let record = try await recordRepo.fetchRecord(id: recordID)
    let book = try await bookRepo.fetchBook(isbn: isbn)
    
    return (record, book)
  }
  
  /// 독서 기록 조회에서 수정된 사항을 업데이트
  func updateRecordInfo(record: Record) async throws {
    try await recordRepo.updateRecord(record)
  }
  
  /// 독서 기록을 삭제
  func deleteRecordInfo(id: String) async throws {
    // 1. 독서 기록을 삭제
    try await recordRepo.deleteRecord(id)
    // 2. 독서 기록이 가지고 있는 메모 삭제
    // 3. 독서 기록이 가지고 있는 문장 삭제
    // 4. 독서 기록이 가지고 있는 요약노트 삭제
  }
}
