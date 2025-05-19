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
  @Published var record: Record
  @Published var book: Book?
  @Published var selectedTab: Int = 0
  
  init(record: Record, example: String? = nil) {
    self.record = record
    self.example = example
  }
  
  // MARK: - Internal Variable
  private var example: String?
  
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
      fetchBook()
      
    case .onTapFavorite:
      record.isFavorite.toggle()
      updateFavorite()
      
    case .onTapDelete:
      deleteRecord()
    }
  }
}

// MARK: - (F)LibraryViewModel
private extension RecordDetailViewModel {
  /// record에 맞는 책 정보를 가져옴
  func fetchBook() {
    guard let bookInfo = DummyData.dummyBooks[record.isbn] else {
      print("Error: Data not found")
      return
    }
    book = bookInfo
    print(bookInfo)
  }
  
  /// record의 즐겨찾기 정보를 업데이트
  func updateFavorite() {
    // id를 기반으로 데이터 찾음
    guard let index = DummyData.dummyRecords.firstIndex(where: { $0.id == record.id }) else {
      print("Error: Data not found")
      return
    }
    DummyData.dummyRecords[index].isFavorite = record.isFavorite
  }
  
  /// record 삭제
  func deleteRecord() {
    guard let index = DummyData.dummyRecords.firstIndex(where: { $0.id == record.id }) else {
      print("Error: Data not found")
      return
    }
    DummyData.dummyRecords.remove(at: index)
  }
}
