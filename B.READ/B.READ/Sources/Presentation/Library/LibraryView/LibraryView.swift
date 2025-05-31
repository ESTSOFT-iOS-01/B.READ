//
//  LibraryView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)LibraryView
struct LibraryView: View {
  enum RecordPresentType {
    case list
    case grid
    
    var image: Image {
      switch self {
      case .list: Image(systemName: SFSymbol.grid.name)
      case .grid: Image(systemName: SFSymbol.list.name)
      }
    }
  }
  
  @StateObject var viewModel: LibraryViewModel
  @State var selectedOption: SortOption = .recent
  @State var showSortMenu: Bool = false
  @State var recordPresentType: RecordPresentType = .list
  
  private let layoutPadding: CGFloat = 16
  
  // MARK: - Init
  // TODO: - 외부 주입을 할지도 몰라서 init으로 해둠
  // -> 외부 주입이 필요없으면 viewModel = LibraryViewModel()로 변경
  init(viewModel: @autoclosure @escaping () -> LibraryViewModel) {
    self._viewModel = .init(wrappedValue: viewModel())
  }
  
  var body: some View {
    ZStack {
      // 메뉴가 열려있을때만 등장 - 불투명 배경, 터치 시 메뉴 닫음
      
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
          SortMenuButton(isOpened: $showSortMenu, selectedOption: $selectedOption)
          
          // 리스트, 그리드 선택 버튼
          Button {
            recordPresentType = (recordPresentType == .list ? .grid : .list)
          } label: {
            recordPresentType.image
          }
          .frame(width: 24, height: 24)
        } // : HStack
        .foregroundStyle(.gray2)
        .padding(.top, layoutPadding)
        
        ZStack(alignment: .topTrailing) {
          // 독서기록 목록 뷰
          if viewModel.state.displayRecords.isEmpty {
            Text("독서 기록이 없습니다.")
              .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if recordPresentType == .list {
            LibraryListView(records: $viewModel.state.displayRecords)
          } else {
            LibraryGridView()
          }
          
          // 정렬 메뉴
          if showSortMenu {
            SortMenu(type: .library, isOpened: $showSortMenu, selectedOption: $selectedOption)
              .padding(.trailing, 24)
              .zIndex(1)
          }
        } // : ZStack
      } // : VStack
      .padding(.top, layoutPadding)
      .padding(.horizontal, 24)
      .onAppear {
        viewModel.send(.onAppear)
      }
      .background(.backgroundDefault)
      
      if showSortMenu {
        Color.black.opacity(0.2)
          .ignoresSafeArea()
          .onTapGesture {
            withAnimation {
              showSortMenu = false
            }
          }
          .zIndex(1)
      }
    } // : ZStack
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
