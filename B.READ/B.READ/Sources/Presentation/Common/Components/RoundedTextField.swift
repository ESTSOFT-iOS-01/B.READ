//
//  RoundedTextField.swift
//  B.READ
//
//  Created by 도민준 on 5/14/25.
//


import SwiftUI

// 1) 분기용 enum
enum ContentType { case nickname, pages }

// 2) 공통 텍스트필드
struct RoundedTextField: View {
  // 필수값
  var type: ContentType
  var placeholder: String
  @Binding var text: String
  
  /// 뷰모델이 던져주는 유효성 결과
  /// nil → 검증 안 함,  true → 초록, false → 빨강
  var isValid: Bool? = nil
  
  var body: some View {
    ZStack(alignment: .leading) {
      
      // 플레이스홀더
      if text.isEmpty {
        Text(placeholder)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.55, letterSpacing: -0.025)
          .foregroundColor(.gray2)
          .padding(.horizontal, 16)
          .padding(.vertical, 13)
          .opacity(text.isEmpty ? 1 : 0)
      }
      
      // 실제 입력
      TextField("", text: $text)
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.55, letterSpacing: -0.025)
        .foregroundColor(.gray3)
        .keyboardType(type == .pages ? .numberPad : .default)
        .onChange(of: text) {
          if type == .pages { filterDigits() }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
    .frame(height: 48)
    .background(.gray0)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(borderColor, lineWidth: 0.8)
    )
    .animation(.easeInOut(duration: 0.15), value: borderColor)
  }
  
  private var borderColor: Color {
    guard !text.isEmpty else { return .clear }  // 입력 전
    guard let isValid = isValid else { return .clear }        // 검증 X
    return isValid ? .brown3 : .red                            // 검증 O
  }
  
  private func filterDigits() {
    let digits = text.filter(\.isNumber)
    if digits != text { text = digits }
  }
}





#Preview {
  @Previewable @State var nickname = ""
  @Previewable @State var pages = ""
  
  
  VStack(spacing: 24) {
    // 닉네임
    RoundedTextField(
      type: .nickname,
      placeholder: "닉네임을 입력해주세요",
      text: $nickname,
      isValid: nickname.count >= 2 ? true : (nickname.isEmpty ? nil : false)
    )
    // 페이지
    RoundedTextField(
      type: .pages,
      placeholder: "0",
      text: $pages,
      isValid: Int(pages).map { (1...999).contains($0) } ?? (pages.isEmpty ? nil : false)
    )
  }
  .padding()
}


