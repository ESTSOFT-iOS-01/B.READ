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
  @ViewBuilder
  func buildView(for scene: RootScene) -> some View {
    switch scene {
    case .home:
      HomeView()
    case .search:
      SearchView(
        inputViewModel: SearchInputViewModel(),
        resultViewModel: SearchResultViewModel(),
        recentSearchViewModel: RecentSearchViewModel(),
        bestSellerViewModel: BestSellerViewModel()
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
