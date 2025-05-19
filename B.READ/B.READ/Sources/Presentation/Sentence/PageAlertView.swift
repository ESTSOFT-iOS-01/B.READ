//
//  PageAlertView.swift
//  B.READ
//
//  Created by 도민준 on 5/19/25.
//

import SwiftUI

struct PageAlertView: View {
  var title: String = "저장 실패"
  var message: String = "올바른 페이지 번호가 아닙니다."
  var onDismiss: () -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      // 내용
      VStack(spacing: 4) {
        Text(title)
          .font(.system(size: 17, weight: .semibold))
        Text(message)
          .font(.system(size: 14))
      }
      .padding(.vertical, 24)
      
      Divider()
      
      Button {
        onDismiss()
      } label: {
        Text("확인")
          .font(.body)
          .foregroundStyle(.green5)
          .frame(maxWidth: .infinity, minHeight: 44)
      }
    }
    .frame(width: 270)
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

#Preview {
  PageAlertView(onDismiss: { })
}
