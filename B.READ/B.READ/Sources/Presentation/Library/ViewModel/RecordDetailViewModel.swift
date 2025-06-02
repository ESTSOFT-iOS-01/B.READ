//
//  RecordViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/19/25.
//

import Foundation
import SwiftUI

// MARK: - (C)RecordDetailVieModel
final class RecordDetailViewModel: ObservableObject {
  
  // MARK: - State
  @Published var record: RecordDetailVO? = nil
  @Published var memos: [MemoVO] = []
  @Published var quotes: [QuoteVO] = []
  @Published var selectedTab: Int = 0
  @Published var selectedSort: [SortOption] = [.recent, .recent]
  
  // MARK: - Internal Variable
  private let recordID: String
  
  init(recordID: String) {
    self.recordID = recordID
  }
  
  // MARK: - Dependency
  @Dependency private var libraryUseCase: LibraryUseCase
  @Dependency private var quoteUseCase: QuoteUseCase
  
  
  // MARK: - Action
  enum Action {
    case onAppear // 뷰 등장 시
    case onTapFavorite // 즐겨찾기 토글 시
    case onTapDelete // 삭제 클릭 시
    case selectSort // 정렬을 선택 시
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task { [weak self] in
        guard let self = self else { return }
        // 1. 상세 독서 기록을 불러옴 - 독서기록 + 메모, 문장
        await self.loadInfo(id: recordID)
        
        await withTaskGroup(of: Void.self) { group in
          // 2. 메모 정렬
          group.addTask {
            await self.sortMemos(by: self.selectedSort[self.selectedTab])
          }
          // 3. 문장 정렬
          group.addTask {
            await self.sortQuotes(by: self.selectedSort[self.selectedTab])
          }
        }
      }
      
    case .onTapFavorite:
      Task { [weak self] in
        guard let self = self else { return }
        
        await self.toggleIsFavorite()
      }
      
    case .onTapDelete:
      Task { [weak self] in
        guard let self = self else { return }
        
        await self.deleteRecord()
      }
      
    case .selectSort:
      Task { [weak self] in
        guard let self = self else { return }
        // 정렬 기준을 변경하면 해당 기준으로 정렬 적용
        if self.selectedTab == 0 {
          await self.sortMemos(by: self.selectedSort[self.selectedTab])
        } else {
          await self.sortQuotes(by: self.selectedSort[self.selectedTab])
        }
      }
      
    }
  }
}

// MARK: - (F)RecordDetailViewModel
private extension RecordDetailViewModel {
  
  /// 독서 기록 조회에서 필요한 정보를 불러옴
  func loadInfo(id: String) async {
    // TODO: - [시르] VO 생성은 전부 비동기 그룹처리
    do {
      // 1. 독서 기록 정보를 불러옴
      let info: (record: Record, book: Book) = try await libraryUseCase.loadRecord(id)
      await MainActor.run {
        // 2. 레코드 상세 VO 생성
        self.record = RecordDetailVO(record: info.record, book: info.book)
        // 3. 메모 VO 생성
        self.memos = info.record.memos.map { MemoVO($0) }
        // 4. 문장 VO 생성
        self.quotes = info.record.quotes.map { QuoteVO($0) }
        // TODO: - [시르] 서머리 VO 정의 후 생성 해야함
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  /// 즐겨 찾기 정보를 업데이트
  func toggleIsFavorite() async {
    
    // 1. 즐겨 찾기 정보를 토글
    await MainActor.run {
      self.record?.isFavorite.toggle()
    }
   
    // 2. 레코드가 없으면 큰 문제
    guard let record = record else {
      print("ViewModel Error: Record Not Found")
      return
    }
    
    do {
      // 3. 정보 업데이트를 위한 Entity생성
      let recordEntity = record.toEntity(memos: memos, quotes: quotes)
      // 4. 생선한 Entity로 업데이트
      try await libraryUseCase.editRecord(recordEntity)
    } catch {
      // TODO: - [시르] 수정 실패 에러 메시지 추가
      print(error.localizedDescription)
    }
  }
  
  /// 독서 기록을 삭제
  func deleteRecord() async {
    // 1. 현재 레코드 정보 확인
    guard let record = self.record else {
      print("ViewModel Error: Record Not Found")
      return
    }
    
    do {
      // 2. 독서 기록 Entity 생성
      let recordEntity = record.toEntity(memos: memos, quotes: quotes)
      // 3. 독서 기록을 삭제
      try await libraryUseCase.deleteRecord(recordEntity)
    } catch {
      // TODO: - [시르] 삭제 실패에 따른 에러 처리
      print(error.localizedDescription)
    }
  }
  
  func sortMemos(by: SortOption = .pageAscending) async {
    // 1. 정렬한 결과
    let sortMemos: [MemoVO] = memos.sorted(by: by.sort)
    
    await MainActor.run {
      self.memos = sortMemos
    }
  }
  
  func sortQuotes(by: SortOption = .recent) async {
    // 1. 정렬한 결과
    let sortQuotes: [QuoteVO] = quotes.sorted(by: by.sort)
    
    await MainActor.run {
      self.quotes = sortQuotes
    }
  }
}
