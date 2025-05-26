//
//  SearchResultView.swift
//  B.READ
//
//  Created by 김도연 on 5/16/25.
//

import SwiftUI

// MARK: - (S)SearchResultView
struct SearchResultView: View {
  @ObservedObject var viewModel: SearchViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  // TODO : 스와이프 제스처로 탭 전환 기능 추가 예정?
  
  let tabs = [
    TabItem(title: "도서"),
    TabItem(title: "내 기록")
  ]
  
  var body: some View {
    VStack(spacing: 2) {
      TopTabBar(tabs: tabs, selectedIndex: $viewModel.state.selectedTabIndex)
        .frame(height: 33) // TODO : toptabbar 바뀌면 frame 안잡아줘도 되나?
        .padding(.horizontal, 24)
      
      SearchTabContentView(
        state: viewModel.state,
        send: viewModel.send
      )
      .padding(.top, 16)
      .animation(.easeInOut(duration: 0.3), value: viewModel.state.selectedTabIndex)
    }
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
  
  // TODO : 이상한 상황이다...원래 유지되어야 정상임 ㅠ
}

#Preview {
  //  SearchResultView(viewModel: SearchViewModel())
  // onAppear에서만 더미데이터 들어감
}

// MARK: - (S)SearchTabContentView
struct SearchTabContentView: View {
  @EnvironmentObject private var coordinator: Coordinator<MainRoute>
  let state: SearchViewModel.SearchViewState
  let send: (SearchViewModel.Action) -> Void
  
  var body: some View {
    Group {
      if state.selectedTabIndex == 0 {
        SearchListView(
          items: state.bookResults,
          layoutPadding: 24,
          listPadding: 16,
          onTap: {
            coordinator.push(.searchBook(isbn: $0.isbn))
          },
          content: { book in
            BookSearchCell(data: book)
          }
        )
        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
      } else {
        SearchListView(
          items: state.recordResults,
          layoutPadding: 24,
          listPadding: 16,
          onTap: {
            coordinator.push(.searchRecord(id: $0.id))
          },
          content: { record in
            RecordSearchCell(data: record)
          }
        )
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
      }
    }
  }
}

// MARK: - (S)SearchListView
struct SearchListView<Data: Identifiable, Content: View>: View {
  let items: [Data]
  let layoutPadding: CGFloat
  let listPadding: CGFloat
  let onTap: (Data) -> Void
  let content: (Data) -> Content
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
          content(item)
            .padding(.horizontal, layoutPadding)
            .onTapGesture {
              onTap(item)
            }
          
          Divider()
            .frame(height: 0.8)
            .background(Color.gray1)
            .padding(.horizontal, layoutPadding)
        }
      }
      .padding(.bottom, listPadding)
    }
  }
}
