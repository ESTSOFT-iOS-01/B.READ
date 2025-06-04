//
//  BestSellerViewModel.swift
//  B.READ
//
//  Created by 김도연 on 6/4/25.
//

import Foundation
import SwiftUI

final class BestSellerViewModel: ObservableObject {
  // MARK: - State
  @Published var error: Error?
  @Published var bestBookList: [BestSellerVO] = []
  
  internal var currentTask: Task<Void, Never>? = nil
  
  @Dependency private var recommandUseCase: RecommandUseCase
  
  enum Action {
    case onAppear
    case cancelTask
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadBestSellerList()
    case .cancelTask:
      currentTask?.cancel()
    }
  }
  
  func loadBestSellerList() {
    currentTask?.cancel()
    currentTask = Task {
      do {
        try Task.checkCancellation()
        let data = try await recommandUseCase.requestBestSeller(in: 0)
        try Task.checkCancellation()
        
        let list = data.map { BestSellerVO($0) }
        
        await MainActor.run {
          bestBookList = list
          error = nil
        }
      } catch {
        if Task.isCancelled { return }
        
        await MainActor.run {
          self.error = error
        }
      }
    }
  }
  
}
