//
//  MainTabView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct MainTabView: View {
  
  @StateObject private var mainCoordinator = Coordinator<MainRoute, SheetRoute>()
  @StateObject private var coordinator = TabCoordinator()
  @State private var selectedTab: TabScene = .home
  
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .backgroundDefault
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
  
  var body: some View {
    TabView(selection: $selectedTab) {
      
      coordinator.buildView(for: .home)
        .tabItem {
          Image(systemName: SFSymbol.house.name)
          Text("홈")
        }
        .tag(TabScene.home)
      
      coordinator.buildView(for: .search)
        .tabItem {
          Image(systemName: SFSymbol.magnify.name)
          Text("검색")
        }
        .tag(TabScene.search)
      
      coordinator.buildView(for: .library)
        .tabItem {
          Image(systemName: SFSymbol.library.name)
          Text("책빵")
        }
        .tag(TabScene.library)
      
      coordinator.buildView(for: .record)
        .tabItem {
          Image(systemName: SFSymbol.record.name)
          Text("기록")
        }
        .tag(TabScene.record)
      
      coordinator.buildView(for: .mypage)
        .tabItem {
          Image(systemName: SFSymbol.myPage.name)
          Text("마이")
        }
        .tag(TabScene.mypage)
    }
    .tint(.brown3)
    .environmentObject(mainCoordinator)
  }
}


#Preview {
  PreviewableContainer {
    MainTabView()
  }
}
