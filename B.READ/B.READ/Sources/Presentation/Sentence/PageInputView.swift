//
//  PageInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct PageInputView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @StateObject var viewModel: PageInputViewModel
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack(spacing: 24) {
      VStack(alignment: .leading, spacing: 8) {
        Text("페이지를 입력해 주세요")
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
        
        HStack(spacing: 16) {
          RoundedTextField(
            type: .pages,
            placeholder: "0",
            text: $viewModel.page,
            isValid: viewModel.isValid
          )
          .focused($isFocused)
          .onChange(of: viewModel.page) {
            viewModel.send(.updatePage)
          }
          
          Text("쪽")
            .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2)
        } // : HStack
      }
      .padding(.horizontal, 24)
      .padding(.top, 16)
      
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(.green1)
        
        ScrollView {
          Text(viewModel.sentence)
            .brStyleFont(
              .pretendard(.semiBold, size: 14),
              lineHeight: 1,
              letterSpacing: -0.025
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        } // : ScrollView
        .scrollIndicators(.hidden)
      } // : ZStack
      .frame(height: 134)
      .padding(.horizontal, 24)
      
    } // : VStack
    .frame(maxHeight: .infinity, alignment: .top)
    .background(Color.backgroundDefault)
    .onTapGesture {
      self.hideKeyboard()
    }
    .task {
      await Task.yield()
      isFocused = true
    } // : task - 페이지입력 텍스트 필드 focus
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("저장") {
          viewModel.send(.submit)
        }
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
        .foregroundStyle(.green6)
        .disabled(!viewModel.isValid)
        .opacity(viewModel.isValid ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isValid)
      }
    } // : toolbar
    .onChange(of: viewModel.didSubmitSuccess) {
      if viewModel.didSubmitSuccess {
        coordinator.pop()
        coordinator.pop()
      }
    }
    .alert("저장 실패", isPresented: $viewModel.showErrorAlert) {
      Button("확인", role: .cancel) { }
    } message: {
      if let error = viewModel.errorMessage {
        Text(error)
      }
    } // : alert
    .animation(.easeInOut(duration: 0.2), value: viewModel.showErrorAlert)
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
        PageInputView(viewModel: .init(record: record, quote: quote))
      }
    }
  }
}
