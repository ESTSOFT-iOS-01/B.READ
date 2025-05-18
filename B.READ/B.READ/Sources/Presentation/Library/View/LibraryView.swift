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
    VStack(spacing: 0) {
      // 상단 탭바
      ScrollView(.horizontal, showsIndicators: false) {
        TopTabBar(tabs: viewModel.tabs, selectedIndex: $selectedIndex) {
          print("\(viewModel.tabs[selectedIndex].title) 탭 선택")
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
      .frame(maxWidth: .infinity, alignment: .trailing)
      .foregroundStyle(.gray2)
      .padding(.top, 16)
      
      // FIXME: - 상태에 따라 뷰를 달리 구성하는 경우, 컨테이너로 묶어서 frame과 같은 설정을 해줘야 하나요?
      // => VStack으로 안감싸는 방법이 있는지 궁금합니다.
      VStack {
        if viewState == .list {
          LibraryListView(records: viewModel.displayRecords)
        }
        else { LibraryGridView() }
      }
      .frame(maxWidth: .infinity)
//      .background(.clear)
      .padding(.top, 8)
    } // : VStack
    .padding(.horizontal, 24)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
  
  // MARK: - (F)sortButton
  // TODO: - 정렬 버튼 공통 컴포넌트로 제작 후, 컴포넌트로 변경
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
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
