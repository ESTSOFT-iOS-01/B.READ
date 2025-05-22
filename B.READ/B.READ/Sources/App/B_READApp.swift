//
//  B_READApp.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

@main
struct B_READApp: App {
  @State private var tabBarCoordinator = TabBarCoordinator()
  
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $tabBarCoordinator.path) {
        MainTabView(coordinator: tabBarCoordinator)
      }
    }
  }
}
