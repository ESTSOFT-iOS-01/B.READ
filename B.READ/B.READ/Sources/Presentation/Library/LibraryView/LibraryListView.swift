//
//  LibraryListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

struct LibraryListView: View {
  let records: [Record]
  
  var body: some View {
    if records.isEmpty {
      // TODO: - (2)독서기록이 없을 때의 뷰
      Text("독서기록이 없습니다.")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      List {
        ForEach(records, id: \.id) { record in
          ZStack {
            NavigationLink(
              destination: RecordDetailView(viewModel: RecordDetailViewModel(record: record))
            ) {
              EmptyView()
            } // : NavigationLink
            .opacity(0)
            
            LibraryListCell(record: record)
              .frame(height: 114)
              .background(.green1.opacity(0.6))
            
          } // : ZStack
          .cornerRadius(16)
          .listRowInsets(EdgeInsets()) // 셀 안쪽 패딩 제거
          .listRowSeparator(.hidden) // separator 제거
          .padding(.vertical, 4)
        } // : ForEach
        
      } // : List
      .listStyle(.plain)
      .scrollIndicators(.hidden)
    }
  }
}

#Preview{
  //  @Previewable @State var records = DummyData.dummyRecords
  LibraryListView(records: DummyData.dummyRecords)
}
