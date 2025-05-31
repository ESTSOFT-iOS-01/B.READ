//
//  MainTabView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct MainTabView: View {
  @State private var selectedTab: Tab = .home
  
  enum Tab {
    case home, search, library, record, mypage
  }
  
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .backgroundDefault

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
  
  var body: some View {
    CoordinatorContainer {
      TabView(selection: $selectedTab) {
        
        HomeView()
          .tabItem {
            Image(systemName: SFSymbol.house.name)
            Text("홈")
          }
          .tag(Tab.home)
        
        SearchView(viewModel: SearchViewModel())
          .tabItem {
            Image(systemName: SFSymbol.magnify.name)
            Text("검색")
          }
          .tag(Tab.search)
        
        LibraryView(viewModel: LibraryViewModel())
          .tabItem {
            Image(systemName: SFSymbol.library.name)
            Text("책빵")
          }
          .tag(Tab.library)
        
        RecordView()
          .tabItem {
            Image(systemName: SFSymbol.record.name)
            Text("기록")
          }
          .tag(Tab.record)
        
        MyPageView()
          .tabItem {
            Image(systemName: SFSymbol.myPage.name)
            Text("마이")
          }
          .tag(Tab.mypage)
      }.tint(.brown3)
    }
  }
}

#Preview {
  MainTabView()
}
