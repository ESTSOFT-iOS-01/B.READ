//
//  TabCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 6/5/25.
//

import SwiftUI

enum TabScene {
  case home
  case search
  case library
  case record
  case mypage
}

final class TabCoordinator: ObservableObject {
  
  // MARK: ViewModel
  let inputViewModel = SearchInputViewModel()
  let resultViewModel = SearchResultViewModel()
  let recentSearchViewModel = RecentSearchViewModel()
  let bestSellerViewModel = BestSellerViewModel()
  
  @ViewBuilder
  func buildView(for scene: TabScene) -> some View {
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
