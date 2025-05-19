//
//  MainTabView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Image(systemName: "house.fill")
          Text("홈")
        }
      
      SearchView(viewModel: SearchViewModel())
        .tabItem {
          Image(systemName: "magnifyingglass")
          Text("검색")
        }
      
      LibraryView(viewModel: LibraryViewModel())
        .tabItem {
          Image(systemName: "books.vertical.fill")
          Text("책빵")
        }
      
      RecordView()
        .tabItem {
          Image(systemName: "doc.text.magnifyingglass")
          Text("기록")
        }
      
      MyPageView()
        .tabItem {
          Image(systemName: "person.fill")
          Text("마이")
        }
    }.tint(.brown3)
  }
}

#Preview {
  MainTabView()
}
