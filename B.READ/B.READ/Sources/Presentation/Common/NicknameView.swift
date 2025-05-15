//
//  NicknameView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct NicknameView: View {
  
  @FocusState private var isFocused: Bool
  @State private var nicknameText = ""
  @State private var isValid = true
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("사용할 닉네임을 입력해주세요.")
        .brStyleFont(.pretendard(.semiBold, size: 24), lineHeight: 1.4)
        .padding(.top, 24)
        .padding(.leading, 6)
      
      Text("영어, 한글, 숫자로 최대 12자까지 설정할 수 있습니다.")
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.35)
        .padding(.leading, 6)
      
      RoundedTextField(
        type: .nickname,
        placeholder: "닉네임을 입력해 주세요",
        text: $nicknameText,
        isValid: isValid
      )
      .padding(.top, 40)
      .focused($isFocused)
      
      BottomButton(buttonTitle: "확인", textColor: .gray3, buttonColor: .gray0) {
        print("next")
      }
      .disabled(nicknameText.isEmpty || !isValid)
      .padding(.horizontal, 4)
      .padding(.bottom, 20)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.horizontal, 26)
    .onChange(of: nicknameText) { oldValue, newValue in
      if newValue.count > 13 {
        nicknameText = oldValue
        return
      }
      
      // 유효성 검사
      let regex = /^[a-zA-Z0-9가-힣]*$/
      isValid = (newValue.wholeMatch(of: regex) != nil)
    }
    .onAppear {
      isFocused = true
    }
  }
}

#Preview {
  NicknameView()
}
