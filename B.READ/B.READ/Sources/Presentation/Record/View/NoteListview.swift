//
//  NoteListview.swift
//  B.READ
//
//  Created by 심근웅 on 6/7/25.
//

import SwiftUI

struct NoteListview: View {
  @EnvironmentObject private var coordinator: Coordinator<MainRoute, SheetRoute>
  @ObservedObject var viewModel: RecordNoteViewModel
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 0) {
        ForEach($viewModel.displayNotes) { $note in
          NoteListCell(note: $note)
            .onTapGesture {
              coordinator.push(
                .summaryDetail(
                  id: note.id,
                  record: note.record,
                  memos: note.memos,
                  quotes: note.quotes
                )
              )
            }
          Divider()
            .frame(height: 0.8)
            .background(.gray1)
        }
        
      } // : LazyVStack
      .padding(.bottom, 40)
    }// : ScrollView
  }
}

#Preview {
  @Previewable @StateObject var viewModel = RecordNoteViewModel()
  PreviewableContainer {
    NoteListview(viewModel: viewModel)
      .onAppear {
        viewModel.send(.onAppear)
      }
  }
}
