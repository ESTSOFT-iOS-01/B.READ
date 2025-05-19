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

  @Environment(\.dismiss) private var dismiss
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

      Spacer()
    }
    .padding(.top, 16)
    .padding(.horizontal, 24)
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("저장") {
          guard let n = pageNumber, (1...999).contains(n) else {
            showInvalidAlert = true
            return
          }
          onSave(n)
        }
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(.green6)
      }
    }
    .overlay {
      if showInvalidAlert {
        Color.black.opacity(0.35).ignoresSafeArea()
        PageAlertView {
          pageText = "0"
          showInvalidAlert = false
          isFocused = true
        }
      }
    }
    .animation(.easeInOut(duration: 0.2), value: showInvalidAlert)

    .background(.backgroundDefault)
    .task {
      await Task.yield()
      isFocused = true
    }
  }
}

#Preview {
  NavigationStack {
    PageInputView(sentence: "미리보기 문장입니다.") { print("page:", $0) }
  }
}
