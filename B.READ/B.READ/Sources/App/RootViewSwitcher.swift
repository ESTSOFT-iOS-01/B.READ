//
//  RootViewSwitcher.swift
//  B.READ
//
//  Created by 신승재 on 5/24/25.
//

import SwiftUI


struct RootViewSwitcher: View {
  @State private var isReady = false
  @State private var coordinator = Coordinator<OnboardingRoute, SheetRoute>()
  @AppStorage("didInitialSetup") private var didInitialSetup: Bool = false
  
  init() {
    UINavigationBar.configureGlobalAppearance()
  }
  
  private var rootScene: RootScene {
    if !isReady { .launch }
    else { didInitialSetup ? .main : .onboarding }
  }
  enum RootScene {
    case launch
    case onboarding
    case main
  }
  
  var body: some View {
    Group {
      switch rootScene {
      case .launch:
        LaunchScreen()
          .task {
            await DIContainer.config()
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run { self.isReady = true }
          }
      case .onboarding:
        OnBoardingView()
          .environmentObject(coordinator)
      case .main:
        MainTabView()
          .transition(.opacity)
      }
    }
    .animation(.linear(duration: 0.3), value: rootScene)
  }
}
