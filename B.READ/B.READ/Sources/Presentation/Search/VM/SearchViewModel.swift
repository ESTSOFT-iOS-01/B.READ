//
//  SearchViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
  
  // MARK: - State
  @Published var state: SearchViewState = .init(
    searchText: "",
    bookList: []
  )
  
  // MARK: - Dependency
  // 예시: 실제 구현에서는 UseCase 주입
  // @Dependency private var searchUseCase: SearchUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case onTapBarcode
    case onTapBestSeller(rank: Int, name: String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadDummyData()
    case .onTapBarcode:
      print("바코드 인식 화면으로 전환")
    case let .onTapBestSeller(rank, name):
      print("\(rank)위 '\(name)' 클릭됨!")
    }
  }
}

// MARK: - Internal Function
private extension SearchViewModel {
  func loadDummyData() {
    state.bookList = [
      "데미안",
      "미씽",
      "싯다르타",
      "하이데거의 사건 존재론",
      "이것이 취업을 위한 코딩테스트다 with Python",
      "풀스택 서버리스",
      "2022 제 16회 젊은작가상 수상작품집",
      "2023 제 16회 젊은작가상 수상작품집",
      "2025 제 16회 젊은작가상 수상작품집",
      "Essentail Grammar in Use with answers and eBook"
    ]
  }
}

struct SearchViewState {
  var searchText: String
  var bookList: [String]
}
