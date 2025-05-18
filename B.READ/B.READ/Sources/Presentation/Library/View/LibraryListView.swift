//
//  LibraryListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

struct LibraryListView: View {
  
  var records: [Record]
  
  var body: some View {
    List {
      ForEach(records, id: \.id) { record in
        LibraryListCell()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
//          .listRowInsets(EdgeInsets()) // 셀 안쪽 패딩 제거
          .listRowSeparator(.hidden) // separator 제거 (iOS 15+)
          .background(.orange.opacity(0.3))
//          .background(Color.clear) // 셀 배경 제거
      } // : ForEach
    } // : List
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .listStyle(.plain)
//    .background(.clear)
    .background(.blue.opacity(0.3))
    .scrollIndicators(.hidden)
    
    
    
    
  }
}
