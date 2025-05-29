//
//  LibraryListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

// MARK: - (S)LibraryListView
struct LibraryListView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  private let records: [LibraryRecordVO]
  @State var selectedRecord: LibraryRecordVO?
  
  init(records: [LibraryRecordVO], selectedRecord: LibraryRecordVO? = nil) {
    self.records = records
    self.selectedRecord = selectedRecord
  }
  
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
            coordinator.push(.libraryDetail(id: record.id, isbn: record.isbn))
          }
      } // : ForEach
      .background(.backgroundDefault)
    } // : List
    .listStyle(.plain)
    .scrollIndicators(.hidden)
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
