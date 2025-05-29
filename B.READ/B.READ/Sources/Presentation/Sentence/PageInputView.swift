//
//  PageInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct PageInputView: View {
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  @StateObject var viewModel: SentenceViewModel = SentenceViewModel(mode: .create(isbn: ""))
  @FocusState private var isFocused: Bool
  @State private var showInvalidAlert = false
  
  private var isValidPage: Bool? {
    guard let limit = viewModel.maxPage else { return nil }   // 아직 로딩 전
    return viewModel.page.map { (1...limit).contains($0) }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("페이지를 입력해 주세요")
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
      
      HStack(spacing: 0) {
        TextField("0",
                  value: $viewModel.page,
                  format: .number)
        .keyboardType(.numberPad)
        .focused($isFocused)
        .frame(height: 44)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(
              isValidPage == nil ? .gray0 :
                (isValidPage! ? Color.green6 : Color.red),
              lineWidth: 1
            )
        )
        
        Text("쪽")
          .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2, letterSpacing: 0)
          .padding(.leading, 16)
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(.green1)
        
        ScrollView(.vertical, showsIndicators: true) {
          Text(viewModel.content)
            .brStyleFont(.pretendard(.semiBold, size: 14), lineHeight: 1, letterSpacing: -0.0025)
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
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("저장") {
          guard let n = viewModel.page, (1...999).contains(n) else {
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
        viewModel.page = 0      // 빈칸으로 리셋
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
  }
}

#Preview {
  NavigationStack {
    PageInputView()
  }
}
