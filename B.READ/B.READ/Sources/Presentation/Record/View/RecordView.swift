//
//  RecordView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)RecordView
struct RecordView: View {
  
  @State private var selectedTab: Int = 0
  @StateObject private var memoViewModel = RecordMemoViewModel()
  @StateObject private var quoteViewModel = RecordQuoteViewModel()
  @StateObject private var noteViewModel = RecordNoteViewModel()
  
  var body: some View {
    VStack(spacing: .zero) {
      TopTabBar(
        tabs: [
          TabItem(title: "메모", image: Image(.menuBread)),
          TabItem(title: "문장", image: Image(.donut)),
          TabItem(title: "빵식이", image: Image(.aiBread))
        ],
        selectedIndex: $selectedTab
      )
      .frame(height: 34)
      .padding(.top, 16)
      
      ZStack {
        if selectedTab == 0 {
          RecordMemoView(viewModel: memoViewModel)
        } else if selectedTab == 1 {
          RecordQuoteView(viewModel: quoteViewModel)
        } else if selectedTab == 2 {
          RecordNoteView(viewModel: noteViewModel)
        }
      }
      .animation(.easeInOut(duration: 0.5), value: selectedTab)
      .padding(.top, 8)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .gesture(
        DragGesture().onEnded { value in
          let distance: CGFloat = 50 // 얼마나 이동하면 인식할지
        
          if value.translation.width < -distance { // 오른쪽 → 왼쪽 (다음 탭)
            if selectedTab < 2 {
              selectedTab += 1
            }
          } else if value.translation.width > distance { // 왼쪽 → 오른쪽 (이전 탭)
            if selectedTab > 0 {
              selectedTab -= 1
            }
          }
        }
      ) // : gesture - 제스처로 탭이동
    } // : VStack
    .padding(.horizontal, 24)
    .background(.backgroundDefault)
  }
}

#Preview {
  PreviewableContainer {
    RecordView()
  }
}
