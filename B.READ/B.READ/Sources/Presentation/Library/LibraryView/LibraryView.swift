//
//  LibraryView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)LibraryView
struct LibraryView: View {
  
  // 뷰 상태(리스트, 그리드)
  enum ViewState {
    case list
    case grid
    
    var image: Image {
      switch self {
      case .list: Image(systemName: LibraryConstants.Icon.grid)
      case .grid: Image(systemName: LibraryConstants.Icon.list)
      }
    }
  }
  
  @ObservedObject var viewModel: LibraryViewModel
  @State var viewState: ViewState = .list
  
  private let layoutPadding: CGFloat = 16
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .trailing, spacing: 0) {
        // 상단 탭바
        ScrollView(.horizontal, showsIndicators: false) {
          TopTabBar(tabs: viewModel.state.tabs, selectedIndex: $viewModel.state.selectedTab)
            .frame(width: 450, height: 34)
            .onChange(of: viewModel.state.selectedTab) {
              viewModel.send(.selectTab)
            }
        }
        
        HStack(spacing: 8) {
          // 정렬 버튼
          sortButton
          // 리스트 / 그리드 선택 버튼
          Button {
            viewState = (viewState == .list ? .grid : .list)
          } label: {
            viewState.image
          }
          .frame(width: 24, height: 24)
        } // : HStack
        .foregroundStyle(.gray2)
        .padding(.top, layoutPadding)
        
        // 독서기록 목록 뷰
        recordView
          .padding(.top, 4)
        
      } // : VStack
      .padding(.top, layoutPadding)
      .padding(.horizontal, 24)
      .onAppear {
        print("onAppear 작동")
        viewModel.send(.onAppear)
      }
    } // : NavigationStack
    .background(.backgroundDefault)
  }
  
  // MARK: - (S)recordView
  // TODO: - (2)그리드 뷰 추가
  private var recordView: some View {
    VStack {
      switch viewState {
      case .list:
        LibraryListView(records: viewModel.state.displayRecords)
      case .grid:
        LibraryGridView()
      }
    }
  }
  
  // MARK: - (S)sortButton
  // TODO: - (2)정렬 버튼 공통 컴포넌트로 제작 후, 컴포넌트로 변경
  // 예시) sortButton(type: .record)
  private var sortButton: some View {
    Button {
      print("정렬 버튼 클릭")
    } label: {
      HStack(spacing: 4) {
        Text("최신 순")
          .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.02)
        Image(systemName: LibraryConstants.Icon.menuOn)
      } // : HStack
    }
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
