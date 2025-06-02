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
    var memos: [MemoVO] = []
    var quotes: [QuoteVO] = []
    var selectedTab: Int = 0
    var selectedQuote: QuoteVO? = nil
  }
  
  @Published var state: RecordDetailState = .init()
  
  // MARK: - Internal Variable
  let recordID: String
  let isbn: String
  
  init(recordID: String, isbn: String) {
    self.recordID = recordID
    self.isbn = isbn
  }
  
  // MARK: - Dependency
  @Dependency private var libraryUseCase: LibraryUseCase
  @Dependency private var quoteUseCase: QuoteUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onTapFavorite
    case onTapDelete
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task { [weak self] in
        guard let self = self else { return }
        
        await self.loadInfo(id: recordID, isbn: isbn)
        await withTaskGroup(of: Void.self) { group in
          group.addTask {
            await self.loadMemos()
          }
          
          group.addTask {
            await self.loadQuote()
            await self.sortQuotes()
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
    }
  }
}


// MARK: - (F)LibraryViewModel
// TODO: - Error 상황에 따른 옳은 행동 추가
private extension RecordDetailViewModel {
  
  /// 독서 기록 조회에서 필요한 정보를 불러옴
  func loadInfo(id: String, isbn: String) async {
    do {
      let info: (Record, Book) = try await libraryUseCase.loadRecord(recordID)
      await MainActor.run { self.state.info = info }
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
      try await libraryUseCase.editRecord(record)
    } catch {
      print(error.localizedDescription)
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
      try await libraryUseCase.deleteRecord(record)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  @MainActor
  /// 메모를 받아옴
  func loadMemos() {
   
  }
  
  /// 문장을 받아옴
  func loadQuote() async {
    // 1. record가 없으면 quote도 없음
    
//    
//    
//    self.state.info?.record.quotes
//    guard let quoteIDs = self.state.info?.record.quoteIDs else {
//      print("ViewModelError.dataNotFound")
//      return
//    }
//    
//    // 2. quoteIDs를 가지고 quote를 받아옴
//    let quoteInfos: [QuoteVO] = await withTaskGroup(of: QuoteVO?.self) { group in
//      for quoteID in quoteIDs {
//        // 그룹에 각 비동기 Task를 추가
//        group.addTask {
//          do {
//            let quote = try await self.quoteUseCase.fetchQuote(id: quoteID)
//            return QuoteVO(quote)
//          } catch {
//            return nil
//          }
//        }
//      }
//      
//      var results: [QuoteVO] = []
//      
//      for await result in group {
//        if let quote = result {
//          results.append(quote)
//        }
//      }
//      return results
//    }
//    
//    await MainActor.run {
//      self.state.quotes = quoteInfos
//    }
  }
  
  // TODO: - (2)Quotes 정렬 내용 추가
  func sortQuotes(by: SortState = .recent) async {
    // 정렬 기준에 따라서 displayRecords를 정렬
    let sortedQuotes: [QuoteVO]
    switch by {
    case .recent:
      sortedQuotes = state.quotes.sorted { $0.page > $1.page }
    case .older:
      sortedQuotes = state.quotes.sorted { $0.page < $1.page }
    }
    
    await MainActor.run {
      self.state.quotes = sortedQuotes
    }
  }
}
