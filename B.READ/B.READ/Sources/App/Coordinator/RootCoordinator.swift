//
//  RootCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 6/5/25.
//

import SwiftUI

enum RootScene {
  case home
  case search
  case library
  case record
  case mypage
}

final class RootCoordinator: ObservableObject {
  
  
  // MARK: Coordinator
  let settingCoordinator = SettingCoordinator()
  
  
  // MARK: ViewModel
  let inputViewModel = SearchInputViewModel()
  let resultViewModel = SearchResultViewModel()
  let recentSearchViewModel = RecentSearchViewModel()
  let bestSellerViewModel = BestSellerViewModel()
  
  @ViewBuilder
  func buildView(for scene: RootScene) -> some View {
    switch scene {
    case .home:
      HomeView()
    case .search:
      SearchView(
        inputViewModel: inputViewModel,
        resultViewModel: resultViewModel,
        recentSearchViewModel: recentSearchViewModel,
        bestSellerViewModel: bestSellerViewModel
      )
    case .library:
      LibraryView()
    case .record:
      RecordView()
    case .mypage:
      MyPageView()
    }
  }
}
