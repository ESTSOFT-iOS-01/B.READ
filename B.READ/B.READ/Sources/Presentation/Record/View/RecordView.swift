//
//  RecordView.swift
//  B.READ
//
//  Created by 신승재 on 5/11/25.
//

import SwiftUI

struct RecordView: View {
  @State var selectedTab: Int = 0
  
  var body: some View {
    VStack {
      TopTabBar(
        tabs: [TabItem(title: "메모"), TabItem(title: "문장"), TabItem(title: "빵식이")],
        selectedIndex: $selectedTab
      )
      .padding(.top, 16)
      
      if selectedTab == 0 {
        RecordMemoView()
      } else if selectedTab == 1 {
        RecordQuoteView()
      } else if selectedTab == 2 {
        RecordNoteView()
      }
      
    } // : VStack
    .padding(.horizontal, 24)
  }
}

#Preview {
  RecordView()
}
