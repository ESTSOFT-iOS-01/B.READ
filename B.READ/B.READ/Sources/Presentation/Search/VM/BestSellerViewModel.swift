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
  
  @Dependency private var recommandUseCase: RecommandUseCase
  
  enum Action {
    case onAppear
  }
  
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      loadBestSellerList()
    }
  }
  
  func loadBestSellerList() {
    Task {
      do {
        let data = try await recommandUseCase.requestBestSeller(in: 0)
        
        let list = data.map { BestSellerVO($0) }
        
        await MainActor.run {
          bestBookList = list
          error = nil
        }
      } catch {
        await MainActor.run {
          self.error = error
        }
      }
    }
  }
  
}
