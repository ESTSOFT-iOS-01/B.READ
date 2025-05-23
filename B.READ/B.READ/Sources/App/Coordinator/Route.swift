//
//  Route.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import SwiftUI

enum SearchRoute: Hashable {
  case barcode
  case searchBook(isbn: String)
  case searchRecord(id: String)
}

enum OnboardingRoute: Hashable {
  // 다른 케이스들 ...
}

final class Coordinator<T: Hashable>: ObservableObject {
  @Published var paths: [T] = []
  
  func push(_ path: T) {
    paths.append(path)
  }
  
  func pop() {
    if !paths.isEmpty {
      paths.removeLast()
    }
  }
  
  func pop(to: T) {
    guard let index = paths.firstIndex(of: to) else { return }
    paths = Array(paths.prefix(upTo: index + 1))
  }
  
  func popToRoot() {
    paths.removeAll()
  }
}


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
