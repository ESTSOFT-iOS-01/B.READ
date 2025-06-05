//
//  MainTabView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct MainTabView: View {
  @StateObject private var rootCoordinator = RootCoordinator()
  @State private var selectedTab: RootScene = .home
  
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .backgroundDefault

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
  
  var body: some View {
    CoordinatorContainer(rootCoordinator: rootCoordinator) {
      TabView(selection: $selectedTab) {

        rootCoordinator.buildView(for: .home)
          .tabItem {
            Image(systemName: SFSymbol.house.name)
            Text("홈")
          }
          .tag(RootScene.home)
        
        rootCoordinator.buildView(for: .search)
          .tabItem {
            Image(systemName: SFSymbol.magnify.name)
            Text("검색")
          }
          .tag(RootScene.search)
        
        rootCoordinator.buildView(for: .library)
          .tabItem {
            Image(systemName: SFSymbol.library.name)
            Text("책빵")
          }
          .tag(RootScene.library)
        
        rootCoordinator.buildView(for: .record)
          .tabItem {
            Image(systemName: SFSymbol.record.name)
            Text("기록")
          }
          .tag(RootScene.record)
        
        rootCoordinator.buildView(for: .mypage)
          .tabItem {
            Image(systemName: SFSymbol.myPage.name)
            Text("마이")
          }
          .tag(RootScene.mypage)
      }.tint(.brown3)
    }
  }
}

#Preview {
  PreviewableContainer {
    MainTabView()
  }
}
