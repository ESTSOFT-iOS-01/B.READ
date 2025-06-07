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
//            .background(.red.opacity(0.3))
            .onTapGesture {
              coordinator.push(.libraryDetail(id: note.recordId))
            }
          Divider()
            .frame(height: 0.8)
            .background(.gray1)
        }
        
      } // : LazyVStack
    }// : ScrollView
  }
  
  
  @ViewBuilder
  private func noteListCell() -> some View {
    
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
