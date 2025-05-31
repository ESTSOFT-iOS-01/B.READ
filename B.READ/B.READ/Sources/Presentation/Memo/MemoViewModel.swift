//
//  MemoViewModel.swift
//  B.READ
//
//  Created by 신승재 on 6/1/25.
//

import Foundation

final class MemoViewModel: ObservableObject {
  
  // MARK: - State
  @Published var createAt: Date = Date()
  @Published var content: String = ""
  @Published var startPage: Int = 0
  @Published var endPage: Int = 0
  @Published var guides: [String] = []
  
  // MARK: - Dependency
  @Dependency
  private var memoUseCase: MemoUseCase
  
  init(id: String) {
    fetchMemo(id: id)
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
  func fetchMemo(id: String) {
    Task { [weak self] in
      guard let self else { return }
      do {
        let memo = try await memoUseCase.fetchMemo(id: id)
        await MainActor.run {
          self.createAt = memo.createdAt
          self.content = memo.content
          self.startPage = memo.pages.0
          self.endPage = memo.pages.1
          self.guides = memo.guides.map { $0.content }
        }
      } catch RepositoryError.dataNotFound {
        return
      } catch {
        print(error)
      }
    }
  }
}
