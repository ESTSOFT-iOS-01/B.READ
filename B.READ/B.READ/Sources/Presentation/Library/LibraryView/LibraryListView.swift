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
  @State var selectedRecord: RecordCellVO?
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 8) {
        ForEach($records) { $record in
          LibraryListCell(record: $record)
            .background(.green1.opacity(0.6))
            .cornerRadius(16)
            .onTapGesture {
              coordinator.push(.libraryDetail(id: record.id, isbn: record.isbn))
            }
        }
      }
    } // : ScrollView
    .scrollIndicators(.hidden)
  }
}

#Preview {
  LibraryView(viewModel: LibraryViewModel())
}
