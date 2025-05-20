//
//  SentenceInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct SentenceInputView: View {
  @Environment(\.dismiss) private var dismiss
  
  @State private var text = ""
  @State private var goNext = false
  @FocusState private var isEditorFocused: Bool
  
  private var trimmedText: String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("기록할 문장을 작성해주세요")
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.4, letterSpacing: -0.0025)
      
      ZStack(alignment: .topLeading) {
        TextEditor(text: $text)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.4, letterSpacing: -0.0025)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .frame(height: 130)     // 고정 높이
          .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
              .fill(Color(.gray0))
          )
          .scrollContentBackground(.hidden)
          .scrollDisabled(false)
          .focused($isEditorFocused)
        
        if text.isEmpty && !isEditorFocused {
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
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button { dismiss() } label: {
          Image(systemName: "chevron.left")
            .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
            .foregroundStyle(.green6)
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button("다음") {
          goNext = true
        }
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.1)
        .foregroundStyle(.green6)
        .disabled(trimmedText.isEmpty)
        .opacity(trimmedText.isEmpty ? 0 : 1)
      }
    }
    .background(.backgroundDefault)
    .navigationDestination(isPresented: $goNext) {
      PageInputView(sentence: trimmedText) { page in
        dismiss()
      }
    }
  }
}

#Preview {
  NavigationStack {
    SentenceInputView()
  }
}
