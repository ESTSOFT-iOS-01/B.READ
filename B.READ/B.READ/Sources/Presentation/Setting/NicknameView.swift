//
//  NicknameView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct NicknameView: View {
  
  // TODO: 코디네이터 완성되면 외부주입으로 변경
  @EnvironmentObject var coordinator: Coordinator<OnboardingRoute>
  @StateObject private var viewModel = SettingViewModel()
  @FocusState private var isFocused: Bool
  @State private var isValid = true
  
  private var isButtonEnabled: Bool {
    !viewModel.nicknameText.isEmpty && isValid
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      InputGuideHeader(type: .nickname)
        .padding(.top, 24)
      
      RoundedTextField(
        type: .nickname,
        placeholder: "닉네임을 입력해 주세요",
        text: $viewModel.nicknameText,
        isValid: isValid
      )
      .padding(.top, 40)
      .focused($isFocused)
      
      BottomButton(
        buttonTitle: "확인",
        textColor: isButtonEnabled ? .backgroundDefault : .gray3,
        buttonColor: isButtonEnabled ? .brown3 : .gray0
      ) {
        viewModel.send(.saveNickname)
        coordinator.push(.selectCategory)
      }
      .disabled(!isButtonEnabled)
      .padding(.horizontal, 4)
      .padding(.bottom, 20)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.horizontal, 26)
    .animation(.easeInOut(duration: 0.25), value: isButtonEnabled)
    .onChange(of: viewModel.nicknameText) { oldValue, newValue in

      if newValue.count >= 13 {
        viewModel.nicknameText = oldValue
        return
      }
      
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
