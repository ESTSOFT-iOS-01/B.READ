//
//  LibraryView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)LibraryView
struct LibraryView: View {
  enum DisplayMode {
    case list
    case grid
    
    var image: Image {
      switch self {
      case .list: Image(systemName: SFSymbol.grid.name)
      case .grid: Image(systemName: SFSymbol.list.name)
      }
    }
  }
  
  @StateObject var viewModel = LibraryViewModel()
  @State var showSortMenu: Bool = false
  @State var displayMode: DisplayMode = .list
  
  @State var selectedOption: SortOption = .recent
  
  private let layoutPadding: CGFloat = 16
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      VStack(alignment: .trailing, spacing: 0) {
        // 상단 탭바
        ScrollView(.horizontal, showsIndicators: false) {
          TopTabBar(tabs: viewModel.state.tabs, selectedIndex: $viewModel.state.selectedTab)
            .frame(width: 450, height: 34)
            .onChange(of: viewModel.state.selectedTab) {
              viewModel.send(.selectTab)
            }
        } // : ScrollView
        
        HStack(spacing: 8) {
          // 정렬 버튼
          SortMenuButton(isOpened: $showSortMenu, selectedOption: $selectedOption)
          
          // 리스트, 그리드 선택 버튼
          Button {
            displayMode = (displayMode == .list ? .grid : .list)
          } label: {
            displayMode.image
          }
          .frame(width: 24, height: 24)
        } // : HStack
        .foregroundStyle(.gray2)
        .padding(.top, layoutPadding)
        
        // 독서기록 목록 뷰
        if viewModel.state.displayRecords.isEmpty {
          Text("독서 기록이 없습니다.")
            .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if displayMode == .list {
          LibraryListView(records: $viewModel.state.displayRecords)
        } else {
          LibraryGridView()
        }
      } // : VStack - 책빵 화면
      .padding(.top, layoutPadding)
      .padding(.horizontal, 24)
      
      if showSortMenu {
        // 메뉴 바깥의 화면 - 터치 시 정렬 메뉴 닫음
        Color.black.opacity(0.2)
          .ignoresSafeArea()
          .onTapGesture {
            showSortMenu = false
          }
        
        // 정렬 메뉴
        SortMenu(type: .library, isOpened: $showSortMenu, selectedOption: $selectedOption)
          .padding(.trailing, 48)
          .padding(.top, 90)
          .onChange(of: selectedOption) {
            viewModel.state.displayRecords = [RecordCellVO(
              record: DummyData.dummyRecords[0],
              book: DummyData.dummyBooks[0])]
          }
        
      }
    } // : ZStack
    .background(.backgroundDefault)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
