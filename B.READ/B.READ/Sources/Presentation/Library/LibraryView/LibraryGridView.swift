//
//  LibraryGridView.swift
//  B.READ
//
//  Created by 심근웅 on 5/17/25.
//

import SwiftUI

// MARK: - (S)LibraryGridView
// TODO: - [시르] 그리드 뷰 구현
struct LibraryGridView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @Binding var records: [RecordCellVO]
  
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 8) {
        ForEach($records) { $record in
          LibraryGridCell(record: $record)
            .onTapGesture {
              // TODO: - [시르] 머지 후, 뷰 연결 수정
              coordinator.push(.libraryDetail(id: record.id))
            }
        }
      } // : LazyVGrid
    } // : ScrollView
    .scrollIndicators(.hidden)
    .padding(.top, 8)
  }
}

#Preview {
  @Previewable @State var record = [
    RecordCellVO(
      record: DummyData.dummyRecords[0],
      book: DummyData.dummyBooks[0]
    ),
    RecordCellVO(
      record: DummyData.dummyRecords[1],
      book: DummyData.dummyBooks[1]
    ),
    RecordCellVO(
      record: DummyData.dummyRecords[2],
      book: DummyData.dummyBooks[2]
    )
  ]
  PreviewableContainer {
    LibraryGridView(records: $record)
      .padding(.all, 24)
  }
}
