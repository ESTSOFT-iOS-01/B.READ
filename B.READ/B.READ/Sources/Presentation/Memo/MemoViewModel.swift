//
//  MemoViewModel.swift
//  B.READ
//
//  Created by 신승재 on 6/1/25.
//

import Foundation

enum GuideStatus {
  case loading, empty, complete
}

final class MemoViewModel: ObservableObject {
  
  // MARK: - State
  @Published var createAt: Date = Date()
  @Published var content: String = ""
  @Published var startPage: String = ""
  @Published var endPage: String = ""
  @Published var guides: [String] = []
  @Published var isSaveComplete: Bool = false
  @Published var guideStatus: GuideStatus = .empty
  
  // MARK: - Internal Variable
  private var memo: Memo?
  
  // MARK: - Dependency
  @Dependency
  private var memoUseCase: MemoUseCase
  
  init(id: String?) {
    guard let id else { return }
    fetchMemo(id: id)
  }
  
  // MARK: - Action
  enum Action {
    case saveMemo
    case generateGuides
    case deleteGuides
  }
  
  func send(_ action: Action) {
    switch action {
    case .saveMemo:
      saveMemo()
    case .generateGuides:
      generateGuides()
    case .deleteGuides:
      self.guides = []
      self.guideStatus = .empty
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
        self.memo = memo
        await MainActor.run {
          self.createAt = memo.createdAt
          self.content = memo.content
          self.startPage = memo.pages.0.toString
          self.endPage = memo.pages.1.toString
          self.guides = memo.guides.map { $0.content }
          self.guideStatus = self.guides.isEmpty ? .empty : .complete
        }
      } catch {
        print(error)
      }
    }
  }
  
  func saveMemo() {
    Task { [weak self] in
      guard let self else { return }
      memo?.content = self.content
      memo?.pages = (Int(self.startPage)!, Int(self.endPage)!)
      memo?.guides = self.guides.map { Guide(date: .now, content: $0) }
      memo?.createdAt = .now
      do {
        if let memo { try await memoUseCase.saveMemo(memo) }
        await MainActor.run { self.isSaveComplete = true }
      } catch {
        print(error)
      }
    }
  }
  
  func generateGuides() {
    Task { [weak self] in
      guard let self else { return }
      
      await MainActor.run { self.guideStatus = .loading }
      
      do {
        // TODO: ISBN DTO 바뀌면 수정해야함
        //let guides = try await memoUseCase.generateGuide(isbn: "")
        try await Task.sleep(nanoseconds: 3_000_000_000) // 3초간 sleep
        await MainActor.run {
          self.guides = ["가이드1", "가이드2", "가이드3", "가이드4", "가이드5"]
        }
      } catch {
        print(error)
      }
      
      await MainActor.run { self.guideStatus = .complete }
    }
  }
}
