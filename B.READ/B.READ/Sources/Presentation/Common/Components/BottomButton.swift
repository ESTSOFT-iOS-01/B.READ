//
//  BottomButton.swift
//  B.READ
//
//  Created by 도민준 on 5/13/25.
//

import SwiftUI

struct BottomButton: View {
  var buttonTitle: String
  var textColor: Color = .backgroundDefault
  var buttonColor: Color = .brown3
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(buttonTitle)
        .brStyleFont(.pretendard(.bold, size: 18), lineHeight: 1.4)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(buttonColor)
        .foregroundColor(textColor)
    }
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  BottomButton(buttonTitle: "버튼") {
    // 액션
  }
}
