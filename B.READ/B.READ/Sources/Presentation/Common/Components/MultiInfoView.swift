//
//  MultiInfoView.swift
//  B.READ
//
//  Created by 김도연 on 6/10/25.
//

import SwiftUI

// MARK: - (S)MultiInfoView
struct MultiInfoView: View {
  let layoutPadding : CGFloat = 16
  let horizontalPadding : CGFloat = 24
  let title : String
  var content: [String]
  
  var body: some View {
    VStack(alignment: .leading, spacing: layoutPadding) {
      Text(title)
        .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 1.2, letterSpacing: 0.02)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      VStack(alignment: .leading, spacing: 12) {
        ForEach(content.indices, id: \.self) { index in
          InnerContentView(content: "• \(content[index])")
        }
      }
    }
    .padding(.horizontal, horizontalPadding)
    .padding(.vertical, layoutPadding)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.white)
  }
}

#Preview {
  MultiInfoView(
    title: "🍞 문장",
    content: [
      "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla eli",
      "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla eli",
      "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla eli",
      "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla eli"
    ])
}
