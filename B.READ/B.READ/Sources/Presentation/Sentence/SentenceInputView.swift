//
//  SentenceInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct SentenceInputView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @StateObject var viewModel: SentenceInputViewModel
  @FocusState private var isEditorFocused: Bool
  
  // MARK: - Init
  init(viewModel: @autoclosure @escaping () -> SentenceInputViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
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
      } // : ZStack
    } // : VStack
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.top, 16)
    .padding(.horizontal, 24)
    .background(Color.backgroundDefault)
    .onTapGesture {
      self.hideKeyboard()
    }
    .task {
      await Task.yield()
      isEditorFocused = true
    } // : task - 페이지입력 텍스트 필드 focus
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("다음") {
          viewModel.send(.submit)
          coordinator.push(.pageInput(record: viewModel.record, quote: viewModel.quote))
        }
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
        .foregroundStyle(.green6)
        .disabled(viewModel.trimmedContent.isEmpty)
        .opacity(viewModel.trimmedContent.isEmpty ? 0 : 1)
        .animation(.easeInOut(duration: 0.2), value: viewModel.trimmedContent.isEmpty)
      } // : ToolbarItem
    } // : toolbar
  }
}

#Preview {
  let record = RecordDetailVO(
    record: DummyData.dummyRecords[1],
    book: DummyData.dummyBooks[1]
  )
  let quote = QuoteVO(
    id: "1",
    isbn: record.isbn,
    content: "테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트 테스트",
    page: 45, record: record
  )
  
  PreviewableContainer {
    CoordinatorContainer {
      NavigationStack {
//        SentenceInputView(viewModel: .init(mode: .create(record: record)))
        SentenceInputView(viewModel: .init(mode: .edit(record: record, quote: quote)))
      }
    }
  }
}
