//
//  SearchCoordinator.swift
//  B.READ
//
//  Created by 김도연 on 5/21/25.
//

import SwiftUI

typealias SearchCoordinatorProtocol = Navigatable & SheetPresentable
typealias SearchAppScene = SearchCoordinator.AppScene

@Observable
final class SearchCoordinator: SearchCoordinatorProtocol {
  
  enum AppScene: Hashable {
    case Barcode
    case SearchResultBook(isbn: String)
    case SearchResultRecord
  }
  
  enum Sheet: Identifiable {
    var id: String { String(describing: self) }
    case CreateRecord
  }
  
  var path: [AppScene] = []
  var sheet: Sheet?
  
  func push(_ page: AppScene) {
    path.append(page)
  }
  
  func pop() {
    if !path.isEmpty {
      path.removeLast()
    }
  }
  
  func popToRoot() {
    path.removeAll()
  }
  
  func presentSheet(_ sheet: Sheet) {
    self.sheet = sheet
  }
  
  func dismissSheet() {
    self.sheet = nil
  }
  
  @ViewBuilder
  func buildPage(_ page: AppScene) -> some View {
    switch page {
    case .Barcode:
      ScanView(viewModel: ScanViewModel(coordinator: self))
        .navigationBarBackButtonHidden(false)
    case let .SearchResultBook(isbn):
      BookDetailView(viewModel: BookViewModel(coordinator: self, isbn: isbn))
    case .SearchResultRecord:
//      ScanView(viewModel: ScanViewModel(coordinator: self))
    }
  }
  
  @ViewBuilder
  func buildSheet(_ sheet: Sheet) -> some View {
    switch sheet {
    case .CreateRecord:
      // 아직 이 부분은 미구현 상태입니다. 추후 추가 예정
      ScanView(viewModel: ScanViewModel(coordinator: self))
    }
  }
}

private struct SearchCoordinatorKey: EnvironmentKey {
  static let defaultValue = SearchCoordinator()
}

extension EnvironmentValues {
  var searchCoordinator: SearchCoordinator {
    get { self[SearchCoordinatorKey.self] }
    set { self[SearchCoordinatorKey.self] = newValue }
  }
}
