//
//  SearchInputViewModel.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import Foundation
import SwiftUI


final class SearchInputViewModel: ObservableObject {
  // MARK: - State
  @Published var searchText: String = "" // 검색창에 입력된 검색어 내용
  @Published var isSubmitted: Bool = false // 검색어가 제출되었는지 여부
  @Published var isFocused: Bool = false // 검색창이 활성화되어있는지 여부
  
  enum Action {
    case onTapClear
    case onSubmitSearch
  }
  
  func send(_ action: Action) {
    switch action {
    case .onTapClear:
      searchText = ""
      isSubmitted = false
      isFocused = true
      
    case .onSubmitSearch:
      guard !searchText.isEmpty else { return }
      isSubmitted = true
      isFocused = false
    }
  }
  
}
