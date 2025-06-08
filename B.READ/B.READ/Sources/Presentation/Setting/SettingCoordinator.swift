//
//  SettingCoordinator.swift
//  B.READ
//
//  Created by 신승재 on 6/5/25.
//

import SwiftUI

enum SettingRoute {
  case nickname
  case categorySelection
}

final class SettingCoordinator: ObservableObject {
  
  let settingViewModel: SettingViewModel
  
  init(settingViewModel: SettingViewModel) {
    self.settingViewModel = settingViewModel
  }
  
  @ViewBuilder
  func buildView(for route: SettingRoute) -> some View {
    switch route {
    case .nickname:
      NicknameView()
    case .categorySelection:
      CategorySelectionView()
    }
  }
}
