//
//  NicknameView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct NicknameView: View {
  @AppStorage("didInitialSetup") private var didInitialSetup: Bool = false
  @EnvironmentObject var onBoardingCoordinator: Coordinator<OnboardingRoute>
  @EnvironmentObject var mainCoordinator: Coordinator<MainRoute>
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
    .onChange(of: viewModel.isSaveComplete) {
      if didInitialSetup {
        mainCoordinator.pop()
      } else {
        onBoardingCoordinator.push(.selectCategory)
      }
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
