//
//  PageInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct PageInputView: View {
  let sentence: String                // 전달받은 문장
  var onSave: (Int) -> Void = { _ in }
  
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  @State private var pageText = "0"
  @State private var showInvalidAlert = false
  @FocusState private var isFocused: Bool
  
  private var pageNumber: Int? { Int(pageText) }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("페이지를 입력해 주세요")
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
      
      // 숫자 입력 필드
      HStack(spacing: 0) {
        RoundedTextField(
          type: .pages,
          placeholder: "0",
          text: $pageText,
          isValid: Int(pageText).map { (1...999).contains($0) } ?? (pageText.isEmpty ? nil : false)
        )
        .focused($isFocused)
        .onChange(of: pageText) { old, new in
          pageText = filteredPage(old: old, new: new)
        }
        
        Text("쪽")
          .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2, letterSpacing: 0)
          .padding(.leading, 16)
      }
      
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(.green1)
        
        ScrollView(.vertical, showsIndicators: true) {
          Text(sentence)
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
          guard let n = pageNumber, (1...999).contains(n) else { //
            showInvalidAlert = true //
            return // todo: 추후 함수 처리
          }
          onSave(n)
          
          // TODO: 추후에 변경
          coordinator.pop()
          coordinator.pop()
        }
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(.green6)
      }
    }
    .alert("저장 실패", isPresented: $showInvalidAlert) {
      Button("확인", role: .cancel) {
        resultInput()
      }
    } message: {
      Text("올바른 페이지 번호가 아닙니다.")
    }
    .animation(.easeInOut(duration: 0.2), value: showInvalidAlert)
    .background(.backgroundDefault)
    .task {
      await Task.yield()
      isFocused = true
    }
  }
  
  private func filteredPage(old: String, new: String) -> String {
    let digits = new.filter(\.isNumber)
    
    if old == "0", let first = digits.last {
      return String(first)
    }
    let trimmed = digits.drop { $0 == "0" }.map(String.init).joined()
    return trimmed.isEmpty ? "0" : trimmed
  }
  
  private func resultInput() {
    pageText = ""
    isFocused = true
  }
}


#Preview {
  NavigationStack {
    PageInputView(sentence: "미리보기 문장입니다.") { print("page:", $0) }
  }
}
