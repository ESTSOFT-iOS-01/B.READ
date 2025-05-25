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


extension Coordinator where T == MainRoute {
  
  @ViewBuilder
  func buildView(for route: T) -> some View {
    switch route {
      
    // MARK: - Search Flow
    case .barcode:
      ScanView(viewModel: ScanViewModel())
    case .searchBook(let isbn):
      BookDetailView(viewModel: BookViewModel(isbn: isbn))
    case .searchRecord(let id):
      BookDetailView(viewModel: BookViewModel(isbn: id))
      
    // MARK: - MyPage Flow
    case .insertNickname:
      NicknameView()
    case .selectCategory:
      CategorySelectionView()
    }
  }
}
