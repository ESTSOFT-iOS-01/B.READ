//
//  LoginView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct LoginView: View {
  
  let subtitle: String = """
  책과 함께한 순간들을
  기록하고 간직하세요.
  언제든 꺼내볼 수 있는 당신만의 책방.
  """
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 0) {
        Text(subtitle)
          .brStyleFont(.pretendard(.light, size: 18), lineHeight: 1.1)
          .padding(.top, 44)
        
        Text("B. READ")
          .brStyleFont(.peaceSans(size: 48), lineHeight: 1.1)
          .padding(.top, 16)
        
        Text("누르면 초기 설정을 시작해요!")
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .foregroundStyle(.gray2)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1)
        
        startButton()
          .padding(.bottom, 280)
          .padding(.top, 16)

      }
      .padding(.horizontal, 56)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  
  // MARK: (F)startButton
  @ViewBuilder
  private func startButton() -> some View {
    Button {
      print("tab")
    } label: {
      Text("시작하기")
        .foregroundStyle(.gray9)
        .brStyleFont(.pretendard(.bold, size: 18), lineHeight: 1.0)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray9, lineWidth: 2)
          )
    }
  }
}

#Preview {
  LoginView()
}
