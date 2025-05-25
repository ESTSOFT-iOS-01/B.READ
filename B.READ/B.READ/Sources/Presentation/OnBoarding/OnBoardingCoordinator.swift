//
//  OnBoardingCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

enum OnboardingRoute: Hashable {
  case login
  case insertNickname
  case selectCategory
}

extension Coordinator where T == OnboardingRoute {
  @ViewBuilder
  func buildView(for route: T) -> some View {
    switch route {
    case .login:
      LoginView()
    case .insertNickname:
      NicknameView()
    case .selectCategory:
      CategorySelectionView()
    }
  }
}
