//
//  SearchResultView.swift
//  B.READ
//
//  Created by 김도연 on 5/16/25.
//

import SwiftUI

// MARK: - (S)SearchResultView
struct SearchResultView: View {
  @ObservedObject var viewModel: SearchResultViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  // TODO : 스와이프 제스처로 탭 전환 기능 추가 예정?
  
  let tabs = [
    TabItem(title: "도서"),
    TabItem(title: "내 기록")
  ]
  
  var body: some View {
    VStack(spacing: 2) {
      TopTabBar(tabs: tabs, selectedIndex: $viewModel.selectedTabIndex)
        .frame(height: 34)
        .padding(.horizontal, 24)
      
      SearchTabContentView(viewModel: viewModel)
      .padding(.top, 16)
      .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTabIndex)
    }
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    .onDisappear {
      viewModel.send(.cancelTask)
    }
  }
  
  // TODO : 이상한 상황이다...원래 유지되어야 정상임 ㅠ
}

#Preview {
  //  SearchResultView(viewModel: SearchViewModel())
  // onAppear에서만 더미데이터 들어감
}

// MARK: - (S)SearchTabContentView
struct SearchTabContentView: View {
  @EnvironmentObject private var coordinator: Coordinator<MainRoute, SheetRoute>
  @ObservedObject var viewModel: SearchResultViewModel
  
  var body: some View {
    Group {
      let text = "\"\(viewModel.searchKeyword)\"에 일치하는 검색 결과가 없습니다."
      
      if viewModel.selectedTabIndex == 0 {
        Group {
          switch viewModel.bookLoadState {
          case .loading:
            if viewModel.bookResults.isEmpty {
              LoadingView()
            } else {
              VStack(spacing: 4) {
                SearchResultCountView(totalBookCount: viewModel.totalBookCount)
                
                SearchListView(
                  items: viewModel.bookResults,
                  layoutPadding: 24,
                  listPadding: 16,
                  onTap: { coordinator.push(.searchBook(isbn: $0.isbn)) },
                  onAppearNearBottom: { viewModel.send(.fetchMoreBooks($0)) },
                  content: { book in
                    BookSearchCell(data: book)
                  }
                )
              }
            }
          case .loaded:
            if viewModel.bookResults.isEmpty {
              FailedView(desp: text)
            } else {
              VStack(spacing: 4) {
                SearchResultCountView(totalBookCount: viewModel.totalBookCount)
                SearchListView(
                  items: viewModel.bookResults,
                  layoutPadding: 24,
                  listPadding: 16,
                  onTap: { coordinator.push(.searchBook(isbn: $0.isbn)) },
                  onAppearNearBottom: { viewModel.send(.fetchMoreBooks($0)) },
                  content: { book in
                    BookSearchCell(data: book)
                  }
                )
              }
            }
          case .failed(let error):
            FailedView(error: error)
          }
        }
        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
      } else {
        Group {
          switch viewModel.recordLoadState {
          case .loading:
            LoadingView()
          case .loaded:
            if viewModel.recordResults.isEmpty {
              FailedView(desp: text)
            } else {
              VStack(spacing: 4) {
                SearchResultCountView(totalBookCount: viewModel.recordResults.count)
                SearchListView(
                  items: viewModel.recordResults,
                  layoutPadding: 24,
                  listPadding: 16,
                  onTap: { coordinator.push(.libraryDetail(id: $0.id)) },
                  onAppearNearBottom: nil,
                  content: { record in
                    RecordSearchCell(data: record)
                  }
                )
              }
            }
          case .failed(let error):
            FailedView(error: error)
          }
        }
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
  let onAppearNearBottom: ((Data) -> Void)?
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
            .onAppear {
              if index >= items.count - 3 {
                onAppearNearBottom?(item)
              }
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

struct SearchResultCountView: View {
  let totalBookCount: Int
  
  var body: some View {
    HStack(spacing: 4) {
      Text("총")
        .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1.2)
        .foregroundStyle(.gray5)
      
      Text("\(totalBookCount)")
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.2)
        .foregroundStyle(.brown9)
      
      Text("개의 검색결과")
        .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1.2)
        .foregroundStyle(.gray5)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 24)
  }
}

#Preview {
  SearchResultCountView(totalBookCount: 123)
}
