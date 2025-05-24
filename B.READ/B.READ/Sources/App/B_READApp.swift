//
//  B_READApp.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

@main
struct B_READApp: App {
  @State private var coordinator = Coordinator<OnboardingRoute>()
  @AppStorage("didInitialSetup") private var didInitialSetup: Bool = true
  
  var body: some Scene {
    WindowGroup {
      Group {
        if didInitialSetup {
          OnBoardingView()
            .environmentObject(coordinator)
        } else {
          MainTabView()
            .transition(.move(edge: .trailing))
        }
      }.animation(.linear(duration: 0.3), value: didInitialSetup)
    }
  }
}
