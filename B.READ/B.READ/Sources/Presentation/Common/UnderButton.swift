//
//  UnderButton.swift
//  B.READ
//
//  Created by 도민준 on 5/13/25.
//

import SwiftUI

struct UnderButton: View {
  var buttonTitle: String
  var textColor: Color
  var buttonColor: Color
  var action: () -> Void = {}
  
  var body: some View {
    Button(action: action) {
      Text(buttonTitle)
        .brStyleFont(.pretendard(.bold, size: 18), lineHeight: 1.4)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    .background(buttonColor)
    .foregroundColor(textColor)
    .cornerRadius(10)
  }
}

#Preview {
  UnderButton(buttonTitle: "버튼", textColor: .brown7, buttonColor: .brown1) {
    // 액션
  }
}
