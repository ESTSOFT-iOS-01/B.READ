//
//  HomeComponentView.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import SwiftUI

struct HomeComponentView: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct RecommandHeaderView: View {
  let categoryName: String
  let text: String = " 추천 도서"
  
  var body: some View {
    Text(buildAttributedText())
      .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
  }
  
  private func buildAttributedText() -> AttributedString {
    var highlight = AttributedString(categoryName)
    let basicString = AttributedString(text)

    highlight.foregroundColor = .orange5
    highlight.font = .pretendard(.semiBold, size: 18)

    highlight.append(basicString)
    return highlight
  }
}

#Preview {
//  HomeComponentView()
  RecommandHeaderView(categoryName: "인문학")
  RecommandHeaderView(categoryName: "경제경영")
  
}
