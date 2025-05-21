//
//  MainTabView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct MainTabView: View {
  @State private var coordinator = TabBarCoordinator()
  
  var body: some View {
    TabView(selection: $coordinator.selectedTab) {
      coordinator.buildPage(.Home)
        .tabItem {
          Image(systemName: "house.fill")
          Text("홈")
        }
        .tag(TabBarAppScene.Home)
      
      coordinator.buildPage(.Search)
        .tabItem {
          Image(systemName: "magnifyingglass")
          Text("검색")
        }
        .tag(TabBarAppScene.Search)
      
      coordinator.buildPage(.Library)
        .tabItem {
          Image(systemName: "books.vertical.fill")
          Text("책빵")
        }
        .tag(TabBarAppScene.Library)
      
      
      coordinator.buildPage(.Record)
        .tabItem {
          Image(systemName: "doc.text.magnifyingglass")
          Text("기록")
        }
        .tag(TabBarAppScene.Record)
      
      coordinator.buildPage(.MyPage)
        .tabItem {
          Image(systemName: "person.fill")
          Text("마이")
        }
        .tag(TabBarAppScene.MyPage)
      
    }.tint(.brown3)
  }
}

#Preview {
  MainTabView()
}
