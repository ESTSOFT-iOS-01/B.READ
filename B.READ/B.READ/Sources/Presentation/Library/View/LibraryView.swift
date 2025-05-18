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
      case .list: Image(systemName: "square.grid.2x2.fill")
      case .grid: Image(systemName: "list.bullet")
      }
    }
  }
  
  @ObservedObject var viewModel: LibraryViewModel
  
  @State var selectedIndex: Int = 0
  @State var viewState: ViewState = .list
  
  
  var body: some View {
    VStack(alignment: .trailing, spacing: 0) {
      // 상단 탭바
      ScrollView(.horizontal, showsIndicators: false) {
        // MARK: - view를 바꾸는게 아닌 viewModel의 records의 값만 필터를 거치는 방법이라 액션 클로저를 추가했습니다.
        TopTabBar(tabs: viewModel.tabs, selectedIndex: $selectedIndex) {
          viewModel.send(.fetchRecordByTab(index: selectedIndex))
        }
        .frame(width: 450, height: 34)
      }
      
      HStack(spacing: 8) {
        // 정렬 버튼
        sortButton()
        // 리스트 / 그리드 선택 버튼
        Button {
          viewState = (viewState == .list ? .grid : .list)
        } label: {
          viewState.image
        }
        .frame(width: 24, height: 24)
      } // : HStack
      .foregroundStyle(.gray2)
      .padding(.top, 16)
      
      // 독서기록 목록 뷰
      recordView()
    } // : VStack
    .padding(.top, 16)
    .padding(.horizontal, 24)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
  
  // MARK: - (F)sortButton
  // TODO: - (2)정렬 버튼 공통 컴포넌트로 제작 후, 컴포넌트로 변경
  // 예시) sortButton(type: .record)
  @ViewBuilder
  private func sortButton() -> some View {
    Button {
      print("정렬 버튼 클릭")
    } label: {
      HStack(spacing: 4) {
        Text("최신 순")
          .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.02)
        Image(systemName: "chevron.compact.down")
      } // : HStack
    }
  }
  
  // MARK: - (F)recordView
  // TODO: - (2)그리드 뷰 추가
  @ViewBuilder
  private func recordView() -> some View {
    if viewState == .list {
      LibraryListView(records: viewModel.displayRecords)
    }
    else {
      LibraryGridView()
    }
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
