//
//  BReadTextField.swift
//  B.READ
//
//  Created by 도민준 on 5/14/25.
//


import SwiftUI

// 1) 분기용 enum
enum FieldKind { case nickname, pages }

// 2) 공통 텍스트필드
struct BReadTextField: View {
  // 필수값
  var kind: FieldKind
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
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.57, letterSpacing: -0.025)
          .foregroundColor(.gray) // Todo Gray200
      }
      
      // 실제 입력
      TextField("", text: $text)
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.57, letterSpacing: -0.025)
        .foregroundColor(.black) // Todo Gray300
        .keyboardType(kind == .pages ? .numberPad : .default)
        .onChange(of: text) {                  
          if kind == .pages { filterDigits() }
        }
    }
    .frame(height: 48)
    .background(.gray) // Todo Gray000
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
