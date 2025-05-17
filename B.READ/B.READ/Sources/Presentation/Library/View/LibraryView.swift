//
//  LibraryView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)LibraryView
struct LibraryView: View {
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
  
  
  @State var viewState: ViewState = .list
  @State var selectedIndex: Int = 0
  
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        TopTabBar(tabs: viewModel.tabs, selectedIndex: $selectedIndex)
          .frame(width: 450, height: 34)
      }
      
      HStack(spacing: 8) {
        Button {
          print("정렬 버튼 클릭")
        } label: {
          HStack(spacing: 4) {
            Text("최신 순")
              .brStyleFont(.pretendard(.medium, size: 12), lineHeight: 1, letterSpacing: -0.02)
            Image(systemName: "chevron.compact.down")
          }
        }
        
        Button {
          viewState = (viewState == .list ? .grid : .list)
        } label: {
          viewState.image
        }
        .frame(width: 24, height: 24)
      } // : HStack
      .frame(maxWidth: .infinity, alignment: .trailing)
      .foregroundStyle(.gray2)
    
      if viewState == .list { LibraryListView() }
      else { LibraryGridView() }
    } // : VStack
    .padding(.horizontal, 24)
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}

