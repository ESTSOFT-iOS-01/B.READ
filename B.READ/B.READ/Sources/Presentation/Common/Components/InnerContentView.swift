//
//  InnerContentView.swift
//  B.READ
//
//  Created by 김도연 on 6/10/25.
//

import SwiftUI

// MARK: - (S)InnerContentView
struct InnerContentView: View {
  var content: String
  
  var body: some View {
    Text(content)
      .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1.2, letterSpacing: -0.025)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  InnerContentView(content: "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum. Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum.")
}
