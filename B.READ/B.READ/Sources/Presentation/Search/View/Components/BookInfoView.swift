//
//  BookInfoView.swift
//  B.READ
//
//  Created by 김도연 on 5/27/25.
//

import SwiftUI

struct BookInfoView: View {
  let layoutPadding : CGFloat = 16
  let title : String
  var content: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: layoutPadding) {
      Text(title)
        .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 1.2, letterSpacing: 0.002)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, layoutPadding)
      
      Text(content)
        .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1.2, letterSpacing: -0.0025)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, layoutPadding)
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity)
    .frame(alignment: .leading)
  }
  
}

#Preview {
  BookInfoView(title: "ISBN", content: "974-123-123123")
  BookInfoView(title: "상세 정보", content: "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum. Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum.")
}
