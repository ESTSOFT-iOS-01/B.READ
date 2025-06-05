//
//  CoordinatorContainer.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

struct CoordinatorContainer<Content: View>: View {
  
  @StateObject private var coordinator = Coordinator<MainRoute, SheetRoute>()
  @ObservedObject var rootCoordinator: RootCoordinator
  
  let content: () -> Content
  
  var body: some View {
    NavigationStack(path: $rootCoordinator.paths) {
      content()
        .navigationDestination(for: SettingRoute.self) { route in
          rootCoordinator.settingCoordinator.builView(for: route)
        }
    }
    .environmentObject(rootCoordinator)
    .environmentObject(coordinator)
  }
}
