//
//  SentenceInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct SentenceInputView: View {
  let mode: SentenceInputMode
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @StateObject var viewModel: SentenceViewModel = SentenceViewModel(mode: .create(isbn: ""))
  @FocusState private var isEditorFocused: Bool
  
  private var trimmedContent: String {
    viewModel.content.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  init(mode: SentenceInputMode) {
    self.mode = mode
    _viewModel = StateObject(
      wrappedValue: SentenceViewModel(mode: mode)
    )
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("기록할 문장을 작성해주세요")
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.4, letterSpacing: -0.025)
      
      ZStack(alignment: .topLeading) {
        TextEditor(text: $viewModel.content)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.4, letterSpacing: -0.025)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .frame(height: 130)
          .background(RoundedRectangle(cornerRadius: 12).fill(Color(.gray0)))
          .scrollContentBackground(.hidden)
          .scrollDisabled(false)
          .focused($isEditorFocused)
          .tint(.gray9)
        
        if viewModel.content.isEmpty && !isEditorFocused {
          Text("여기를 터치해서 문장을 입력할 수 있어요")
            .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1, letterSpacing: -0.025)
            .foregroundStyle(.gray2)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .allowsHitTesting(false)
        }
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.top, 16)
    .padding(.horizontal, 24)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("다음") {
                 coordinator.push(
                   .pageInput(mode: mode,
                              sentence: trimmedContent)
                 )
               }
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
        .foregroundStyle(.green6)
        .disabled(trimmedContent.isEmpty)
        .opacity(trimmedContent.isEmpty ? 0 : 1)
      }
    }
    .background(Color.backgroundDefault)
  }
}

#Preview {
  let dummy = Coordinator<MainRoute>()
  
  NavigationStack {
    SentenceInputView(mode: .create(isbn: "9781234567890"))
  }
  .environmentObject(dummy)           
}
