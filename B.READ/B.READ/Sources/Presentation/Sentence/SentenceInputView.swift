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
  @StateObject var viewModel: SentenceViewModel
  @FocusState private var isEditorFocused: Bool
  @State private var showPageAlert = false
  
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
          guard viewModel.maxPage != nil else {
            showPageAlert = true
            return
          }
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
    .alert("페이지 정보를 불러오는 중입니다",
           isPresented: $showPageAlert) {
      Button("확인", role: .cancel) { }
    } message: {
      Text("잠시 후 다시 시도해 주세요.")
    }
    .background(Color.backgroundDefault)
    .onTapGesture {
      self.hideKeyboard()
    }
  }
}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

#Preview {
  PreviewableContainer {
    let dummy = Coordinator<MainRoute, SheetRoute>()
    let record = RecordDetailVO(record: DummyData.dummyRecords[1], book: DummyData.dummyBooks[1])
    NavigationStack {
      SentenceInputView(mode: .create(record: record))
    }
    .environmentObject(dummy)
  }
}
