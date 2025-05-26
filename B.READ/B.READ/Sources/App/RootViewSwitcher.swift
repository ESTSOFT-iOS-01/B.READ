//
//  RootViewSwitcher.swift
//  B.READ
//
//  Created by 신승재 on 5/24/25.
//

import SwiftUI


struct RootViewSwitcher: View {
  
  @State private var coordinator = Coordinator<OnboardingRoute>()
  @AppStorage("didInitialSetup") private var didInitialSetup: Bool = false
  
  init() {
    UINavigationBar.configureGlobalAppearance()
  }
  
  private var rootScene: RootScene { didInitialSetup ? .main : .onboarding }
  enum RootScene {
    case onboarding
    case main
  }
  
  var body: some View {
    Group {
      switch rootScene {
      case .onboarding:
        OnBoardingView()
          .environmentObject(coordinator)
      case .main:
        MainTabView()
          .transition(.move(edge: .trailing))
      }
    }
    .animation(.linear(duration: 0.3), value: rootScene)
  }
}

#Preview {
  RootViewSwitcher()
}
