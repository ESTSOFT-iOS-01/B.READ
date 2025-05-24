//
//  MainTabView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct MainTabView: View {
  @State private var searchCoordinator = Coordinator<SearchRoute>()
  @State private var myPageCoordinator = Coordinator<MyPageRoute>()
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
    TabView(selection: $selectedTab) {
      HomeView()
        .tabItem {
          Image(systemName: "house.fill")
          Text("홈")
        }
        .tag(Tab.home)
      
      SearchView(viewModel: SearchViewModel())
        .environmentObject(searchCoordinator)
        .tabItem { Label("검색", systemImage: "magnifyingglass") }
        .tag(Tab.search)
      
      LibraryView(viewModel: LibraryViewModel())
        .tabItem {
          Image(systemName: "books.vertical.fill")
          Text("책빵")
        }
        .tag(Tab.library)
      
      RecordView()
        .tabItem {
          Image(systemName: "doc.text.magnifyingglass")
          Text("기록")
        }
        .tag(Tab.record)
      
      MyPageView()
        .environmentObject(myPageCoordinator)
        .tabItem {
          Image(systemName: "person.fill")
          Text("마이")
        }
        .tag(Tab.mypage)
      
    }.tint(.brown3)
  }
}

#Preview {
  MainTabView()
}
