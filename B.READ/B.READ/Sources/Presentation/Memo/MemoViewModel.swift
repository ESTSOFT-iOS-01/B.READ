//
//  MemoViewModel.swift
//  B.READ
//
//  Created by 신승재 on 6/1/25.
//

import Foundation

final class MemoViewModel: ObservableObject {
  
  // MARK: - State
  @Published var content: String = ""
  @Published var startPage: Int = 0
  @Published var endPage: Int = 0
  @Published var guides: [String] = []
  
  // MARK: - Dependency
  @Dependency
  private var memoUseCase: MemoUseCase
  
  init() {
    fetchCurrentMemo()
  }
  
  // MARK: - Action
  enum Action {
    case saveMemo
    case generateGuides
  }
  
  func send(_ action: Action) {
    switch action {
    case .saveMemo:
      print("saveMemo")
    case .generateGuides:
      print("generateGuides")
    }
  }
}

// MARK: - Internal Function
private extension MemoViewModel {
  func fetchCurrentMemo() {
    
  }
}
