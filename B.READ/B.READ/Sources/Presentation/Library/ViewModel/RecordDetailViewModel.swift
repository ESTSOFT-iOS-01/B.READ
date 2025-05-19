//
//  RecordViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 5/19/25.
//

import Foundation

final class RecordDetailViewModel: ObservableObject {
  
  // MARK: - State
  @Published var record: Record
  
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
      return
      
    case .onTapFavorite:
      record.isFavorite.toggle()
      updateFavorite()
      
    case .onTapDelete:
      deleteRecord()
    }
  }
}

// MARK: - Internal Function
private extension RecordDetailViewModel {
  
  /// record의 즐겨찾기 정보를 업데이트
  func updateFavorite() {
    // id를 기반으로 데이터 찾음
    guard let index = DummyData.dummyRecords.firstIndex(where: { $0.id == record.id }) else {
      print("Error: Data not found")
      return
    }
    DummyData.dummyRecords[index].isFavorite = record.isFavorite
  }
  
  func deleteRecord() {
    guard let index = DummyData.dummyRecords.firstIndex(where: { $0.id == record.id }) else {
      print("Error: Data not found")
      return
    }
    DummyData.dummyRecords.remove(at: index)
  }
  
//  func initialize() {
//    Task {
//      do {
//        let datas = try await exampleUseCase.fetchDatas()
//        // UI 상태를 변경할 시에는 명시적으로 작성해줍니다.
//        // 또한 변수에 할당 시 self 명시해줍니다.(함수는 X)
//        await MainActor.run { self.datas = datas }
//      } catch {
//        print(error)
//      }
//    }
//  }
}
