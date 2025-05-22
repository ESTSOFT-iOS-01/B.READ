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
  
  private var isButtonEnabled: Bool {
    !nicknameText.isEmpty && isValid
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      InputGuideHeader(type: .nickname)
        .padding(.top, 24)
      
      RoundedTextField(
        type: .nickname,
        placeholder: "닉네임을 입력해 주세요",
        text: $nicknameText,
        isValid: isValid
      )
      .padding(.top, 40)
      .focused($isFocused)
      
      BottomButton(
        buttonTitle: "확인",
        textColor: isButtonEnabled ? .backgroundDefault : .gray3,
        buttonColor: isButtonEnabled ? .brown3 : .gray0
      ) {
        print("next")
      }
      .disabled(!isButtonEnabled)
      .padding(.horizontal, 4)
      .padding(.bottom, 20)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.horizontal, 26)
    .animation(.easeInOut(duration: 0.25), value: isButtonEnabled)
    .onChange(of: nicknameText) { oldValue, newValue in
      // 글자수 제한
      if newValue.count >= 13 {
        nicknameText = oldValue
        return
      }
      
      // 유효성 검사
      let regex = /^[a-zA-Z0-9가-힣]*$/
      isValid = newValue.contains(regex)
    }
    .task {
      await Task.yield()
      isFocused = true
    }
  }
}

#Preview {
  NicknameView()
}
