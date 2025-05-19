//
//  SentenceInputView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//


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
  @State private var frozenText = ""
  
  private var cleaned: String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("기록할 문장을 작성해주세요")
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2, letterSpacing: 0)
      
      ZStack(alignment: .topLeading) {
        TextEditor(text: $text)
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .frame(height: 130)     // 고정 높이
          .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
              .fill(Color(.gray0))
          )
          .scrollContentBackground(.hidden)
          .scrollDisabled(false)
        
        if text.isEmpty {
          Text("여기를 터치해서 문장을 입력할 수 있어요")
            .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1, letterSpacing: -0.025)
            .foregroundStyle(.gray2)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .allowsHitTesting(false)
        }
      }
      Spacer()
    }
    .padding(.top, 16)
    .padding(.horizontal, 24)
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button { dismiss() } label: {
          Image(systemName: "chevron.left")
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(.green6)
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("다음") {
          frozenText = cleaned
          goNext = true
        }
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(.green6)
        .disabled(cleaned.isEmpty)
        .opacity(cleaned.isEmpty ? 0 : 1)
      }
    }
    .background(.backgroundDefault)
    .navigationDestination(isPresented: $goNext) {
      PageInputView(sentence: frozenText) { page in
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
