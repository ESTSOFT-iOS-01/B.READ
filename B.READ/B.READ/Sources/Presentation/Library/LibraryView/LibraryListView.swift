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
  @Binding var records: [RecordCellVO]
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 8) {
        ForEach($records) { $record in
          LibraryListCell(record: $record)
            .background(.green1.opacity(0.6))
            .cornerRadius(16)
            .onTapGesture {
              coordinator.push(.libraryDetail(id: record.id))
            }
        }
      }
    } // : ScrollView
    .scrollIndicators(.hidden)
    .padding(.top, 8)
  }
}

#Preview {
  @Previewable @State var records: [RecordCellVO] = [
    RecordCellVO(record: DummyData.dummyRecords[0], book: DummyData.dummyBooks[0]),
    RecordCellVO(record: DummyData.dummyRecords[1], book: DummyData.dummyBooks[1]),
    RecordCellVO(record: DummyData.dummyRecords[2], book: DummyData.dummyBooks[2])
  ]
  PreviewableContainer {
    LibraryListView(records: $records)
  }
}
