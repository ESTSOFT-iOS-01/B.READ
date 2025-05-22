//
//  TabBarCoordinator.swift
//  B.READ
//
//  Created by 김도연 on 5/21/25.
//

import SwiftUI

typealias TabBarCoordinatorProtocol = Navigatable
typealias TabBarAppScene = TabBarCoordinator.AppScene

@Observable
final class TabBarCoordinator: Navigatable {
  
  let searchCoordinator = SearchCoordinator()
  
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
  var path: [AppScene] = []
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

