//
//  ContentView.swift
//  B.READ
//
//  Created by 신승재 on 5/7/25.
//

import SwiftUI

struct ContentView: View {
  
  let text =
  """
  책에 남긴 문장과 메모,
  빵식이가 정리해두었어요.
  따뜻하게 담아낸 기록,
  하루를 마무리하며 꺼내보세요.
  """
  
  var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .brStyleFont(
          .pretendard(.light, size: 18),
          lineHeight: 1.6,
          letterSpacing: 0.02
        )
    }
  }
}

#Preview {
  ContentView()
}
