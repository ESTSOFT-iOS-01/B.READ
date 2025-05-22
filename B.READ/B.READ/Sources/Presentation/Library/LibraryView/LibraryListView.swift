//
//  LibraryListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

struct LibraryListView: View {
  let records: [LibraryRecordVO]
  @State var selectedRecord: LibraryRecordVO? = nil
  
  var body: some View {
    List {
      ForEach(records) { record in
        LibraryListCell(record: record)
          .background(.green1.opacity(0.6))
          .cornerRadius(16)
          .listRowInsets(EdgeInsets()) // 셀 안쪽 패딩 제거
          .listRowSeparator(.hidden) // separator 제거
          .padding(.top, 8)
          .onTapGesture {
            selectedRecord = record
          }
      } // : ForEach
    } // : List
    .listStyle(.plain)
    .scrollIndicators(.hidden)
    .navigationDestination(item: $selectedRecord) { record in
      RecordDetailView(viewModel: RecordDetailViewModel(recordID: record.id, isbn: record.isbn))
    }
  }
}
