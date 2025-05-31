//
//  PageInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct PageInputView: View {
  let mode: SentenceInputMode
  let sentence: String
  
  @State private var pageText: String = "0"
  @StateObject private var viewModel: SentenceViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @State private var showInvalidAlert = false
  @FocusState private var isFocused: Bool
  
  init(mode: SentenceInputMode, sentence: String) {
    self.mode = mode
    self.sentence = sentence
    _viewModel = StateObject(wrappedValue: SentenceViewModel(mode: mode))
  }
  
  
  var body: some View {
    let isValidPage: Bool? = {
      guard let limit = viewModel.maxPage else { return nil }
      return Int(pageText).map { (1...limit).contains($0) }
    }()
    
    VStack(alignment: .leading, spacing: 8) {
      Text("페이지를 입력해 주세요")
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
      HStack(spacing: 0) {
        RoundedTextField(
          type: .pages,
          placeholder: "0",
          text: $pageText,
          isValid: isValidPage
        )
        .focused($isFocused)
        
        Text("쪽")
          .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2)
          .padding(.leading, 16)
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(.green1)
        
        ScrollView(.vertical, showsIndicators: true) {
          Text(viewModel.content)
            .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 1, letterSpacing: -0.025)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      .frame(height: 134)
      .padding(.top, 24)
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.top, 16)
    .padding(.horizontal, 24)
    .onChange(of: pageText) {
      viewModel.page = Int($0)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("저장") {
          guard
            let pageNumber   = viewModel.page,
            let isPageValid  = isValidPage,
            isPageValid
          else {
            showInvalidAlert = true
            return
          }
          viewModel.send(.submit)
          coordinator.pop()
          coordinator.pop()
        }
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
        .foregroundStyle(.green6)
      }
    }
    .alert("저장 실패", isPresented: $showInvalidAlert) {
      Button("확인", role: .cancel) {
        viewModel.page = nil
        pageText = ""
        isFocused = true
      }
    } message: {
      Text("올바른 페이지 번호가 아닙니다.")
    }
    .animation(.easeInOut(duration: 0.2), value: showInvalidAlert)
    .background(Color.backgroundDefault)
    .task {
      await Task.yield()
      isFocused = true
    }
    .onAppear {
      if viewModel.content.isEmpty {
        viewModel.content = sentence
      }
      if pageText.isEmpty {
        pageText = viewModel.page.map(String.init) ?? ""
      }
    }
  }
}

#Preview {
  NavigationStack {
    PageInputView(mode: .create(isbn: "9781234567890"), sentence: "")
  }
}
