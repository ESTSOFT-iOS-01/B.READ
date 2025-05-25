//
//  MainCoordinatorContainer.swift
//  B.READ
//
//  Created by 신승재 on 5/25/25.
//

import SwiftUI

struct MainCoordinatorContainer<Content: View>: View {
  
  @StateObject private var coordinator = Coordinator<MainRoute>()
  
  let content: () -> Content
  
  var body: some View {
    NavigationStack(path: $coordinator.paths) {
      content()
        .navigationDestination(for: MainRoute.self) { route in
          coordinator.buildView(for: route)
        }
    }.environmentObject(coordinator)
  }
}
