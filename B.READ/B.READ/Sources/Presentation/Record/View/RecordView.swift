//
//  RecordView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

// MARK: - (S)RecordView
struct RecordView: View {
  @State var selectedTab: Int = 0
  
  var body: some View {
    VStack(spacing: .zero) {
      TopTabBar(
        tabs: [TabItem(title: "메모"), TabItem(title: "문장"), TabItem(title: "빵식이")],
        selectedIndex: $selectedTab
      )
      .frame(height: 34)
      .padding(.top, 16)
      
      Group {
        if selectedTab == 0 {
          RecordMemoView()
        } else if selectedTab == 1 {
          RecordQuoteView()
        } else if selectedTab == 2 {
          RecordNoteView()
        }
      } // : Group
      .padding(.top, 8)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    } // : VStack
    .padding(.horizontal, 24)
    .background(.backgroundDefault)
  }
}

#Preview {
  RecordView()
}
