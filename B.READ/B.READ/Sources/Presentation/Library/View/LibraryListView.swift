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
      if records.isEmpty {
        // TODO: - 독서기록이 없을 때의 뷰 or 테스트 추가해야함.
        Text("독서기록이 없습니다.")
      } else {
        ForEach(records, id: \.id) { record in
          LibraryListCell(record: record)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listRowInsets(EdgeInsets()) // 셀 안쪽 패딩 제거
            .listRowSeparator(.hidden) // separator 제거
            .background(.orange2.opacity(0.3))
        } // : ForEach
      }
    } // : List
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .listStyle(.plain)
    .scrollIndicators(.hidden)
  }
}
