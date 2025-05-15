//
//  NicknameView.swift
//  B.READ
//
//  Created by 신승재 on 5/15/25.
//

import SwiftUI

struct NicknameView: View {
  var body: some View {
    VStack {
      Text("사용할 닉네임을 입력해주세요.")
      Text("영어, 한글, 숫자로 최대 12자까지 설정할 수 있습니다.")
    }
  }
}

#Preview {
  NicknameView()
}
