//
//  SearchCoordinator.swift
//  B.READ
//
//  Created by 김도연 on 5/21/25.
//

import SwiftUI

typealias SearchCoordinatorProtocol = Navigatable & SheetPresentable
typealias SearchAppScene = SearchCoordinator.AppScene

final class SearchCoordinator: SearchCoordinatorProtocol {
  
  enum AppScene: Hashable {
    case Barcode
    case SearchResultBook
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
    path.removeLast()
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
      ScanView()
        .navigationBarBackButtonHidden(false)
    case .SearchResultBook:
      ScanView()
    case .SearchResultRecord:
      ScanView()
    }
  }
  
  @ViewBuilder
  func buildSheet(_ sheet: Sheet) -> some View {
    switch sheet {
    case .CreateRecord:
      ScanView()
    }
  }
}
