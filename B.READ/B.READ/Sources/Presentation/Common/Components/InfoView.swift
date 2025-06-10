//
//  InfoView.swift
//  B.READ
//
//  Created by 김도연 on 6/10/25.
//

import SwiftUI

// MARK: - (S)InfoView
struct InfoView: View {
  let layoutPadding : CGFloat = 16
  let title : String
  var content: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: layoutPadding) {
      Text(title)
        .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 1.2, letterSpacing: 0.02)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      InnerContentView(content: content)
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.white)
  }
}

#Preview {
  InfoView(title: "📚 요약", content: "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum. Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum.")
  
}
