//
//  Coordinator.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import SwiftUI

@MainActor
final class Coordinator<T: Hashable>: ObservableObject {
  @Published var paths: [T] = []
  
  init(initial: T? = nil) {
    if let initial = initial {
      self.paths = [initial]
    } else {
      self.paths = []
    }
  }
  
  func push(_ path: T) {
    guard paths.last != path else { return }
    print("Before push: \(paths)")
    paths.append(path)
    print("After push: \(paths)")
  }

  func pop() {
    guard !paths.isEmpty else { return }
    print("Before pop: \(paths)")
    paths.removeLast()
    print("After pop: \(paths)")
  }

  func popToRoot() {
    print("Before popToRoot: \(paths)")
    paths.removeAll()
    print("After popToRoot: \(paths)")
  }
  
  func pop(to: T) {
    guard let index = paths.firstIndex(of: to) else { return }
    paths = Array(paths.prefix(upTo: index + 1))
  }

}

// MARK: - Onboarding Flow
extension Coordinator where T == OnboardingRoute {
  @ViewBuilder
  func buildView(for route: OnboardingRoute) -> some View {
    switch route {
    case .insertNickname:
      NicknameView()
    case .selectCategory:
      CategorySelectionView()
    case .mainTabBar:
      MainTabView()
    }
  }
}

// MARK: - Search Flow
extension Coordinator where T == SearchRoute {
  @ViewBuilder
  func buildView(for route: SearchRoute) -> some View {
    switch route {
    case .barcode:
      ScanView(viewModel: ScanViewModel())
    case .searchBook(let isbn):
      BookDetailView(viewModel: BookViewModel(isbn: isbn))
    case .searchRecord(let id):
      BookDetailView(viewModel: BookViewModel(isbn: id))
    }
  }
}


