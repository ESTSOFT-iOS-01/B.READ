//
//  RecentSearchViewModel.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import Foundation
import SwiftUI

final class RecentSearchViewModel: ObservableObject {
  
  // MARK: - State
  @Published var keywords: [String] = [] // 최근 검색어 리스트 - 검색창 활성화시에만 보여짐
  
  // MARK: - Dependency
  @Dependency private var profileUseCase: ProfileUseCase
  
  // MARK: - Action
  enum Action {
    case onAppear
    case addKeyword(String)
    case deleteKeyword(String)
    case deleteAllKeywords
    case selectKeyword(String)
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      execute { [weak self] in
        try await self?.fetch()
      }
      
    case let .addKeyword(keyword),
         let .selectKeyword(keyword):
      execute { [weak self] in
        try await self?.profileUseCase.addRecentKeyword(keyword)
        try await self?.fetch()
      }
      
    case let .deleteKeyword(keyword):
      execute { [weak self] in
        try await self?.profileUseCase.deleteRecentKeyword(keyword)
        try await self?.fetch()
      }
      
    case .deleteAllKeywords:
      execute { [weak self] in
        try await self?.profileUseCase.clearRecentKeywords()
        try await self?.fetch()
      }
    }
  }
  
  private func fetch() async throws {
    let result = try await profileUseCase.fetchRecentKeywords()
    await MainActor.run {
      keywords = result
    }
  }
  
  private func execute(_ operation: @escaping () async throws -> Void) {
    Task {
      do {
        try await operation()
      } catch {
        print("Error: \(error)")
      }
    }
  }
  
}
