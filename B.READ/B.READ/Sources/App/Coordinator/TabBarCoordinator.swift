//
//  TabBarCoordinator.swift
//  B.READ
//
//  Created by 김도연 on 5/21/25.
//

import SwiftUI

typealias TabBarCoordinatorProtocol = Navigatable
typealias TabBarAppScene = TabBarCoordinator.AppScene

@MainActor
@Observable
final class TabBarCoordinator: Navigatable {
  var path: [AppScene]

//  let homeCoordinator = HomeCoordinator()
  let searchCoordinator = SearchCoordinator()
//  let libraryCoordinator = LibraryCoordinator()
//  let recordCoordinator = RecordCoordinator()
//  let myPageCoordinator = MyPageCoordinator()
  
  // MARK: - Enum
  // TODO : 뷰모델 외부에서 주입시 enum 스타일 변경
  enum AppScene: Hashable {
    case Home
    case Search
    case Library
    case Record
    case MyPage
  }
  
  // MARK: - NavigationStack 상태 관리
  var searchPath: [SearchAppScene] = []
  var selectedTab: AppScene = .Home
  
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
  
  @ViewBuilder
  func buildPage(_ page: AppScene) -> some View {
    switch page {
    case .Home:
      HomeView()
    case .Search:
      SearchView(viewModel: SearchViewModel(coordinator: searchCoordinator))
    case .Library:
      LibraryView(viewModel: LibraryViewModel())
    case .Record:
      RecordView()
    case .MyPage:
      MyPageView()
    }
  }
  
}


