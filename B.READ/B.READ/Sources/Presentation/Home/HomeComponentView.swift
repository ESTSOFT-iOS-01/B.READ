//
//  HomeComponentView.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import SwiftUI

// MARK: - (S)RecommandHeaderView
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

// MARK: - (S)RecommandCell
struct RecommandCell: View {
  var bestSellerVO : BestSellerVO
  var onTap: () -> Void
  
  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      LargeImageView(
        imageURL: ImageURLConverter.highQualityURL(from: bestSellerVO.imageURL),
        frameSize: (85, 130)
      )
      .padding(.top, 16)
      
      VStack(alignment: .leading, spacing: 0) {
        Text(bestSellerVO.title)
          .brStyleFont(
            .pretendard(.semiBold, size: 16),
            lineHeight: 1.5,
            letterSpacing: -0.025
          )
          .foregroundStyle(.brown9)
          .lineLimit(1)
          .truncationMode(.tail)
        
        Text(bestSellerVO.author)
          .brStyleFont(
            .pretendard(.light, size: 12),
            lineHeight: 1.35,
            letterSpacing: -0.02
          )
          .foregroundStyle(.gray2)
          .lineLimit(1)
          .truncationMode(.tail)
      }
      .frame(width: 142, alignment: .leading)
      .padding(.horizontal, 16)
      .padding(.bottom, 24)
    }
    .background(.white)
    .clipShape(
      RoundedRectangle(cornerRadius: 10)
    )
//    .shadow(color: .gray2.opacity(0.25), radius: 25, x: 0, y: 2)
    .padding(.leading, 24)
    .onTapGesture(perform: onTap)
  }
}

#Preview {
  //  RecommandHeaderView(categoryName: "인문학")
//    RecommandHeaderView(categoryName: "경제경영")
  
  LazyHStack(spacing: 24) {
    RecommandCell(
      bestSellerVO: BestSellerVO(
        id: "1",
        rank: 1,
        isbn: "9788932043562",
        title: "빛과 실 - 2024 노벨문학상 수상 강연문 수록, 2024 노벨문학상 수상작가",
        author: "한강 (지은이)",
        imageURL: "https://image.aladin.co.kr/product/36101/66/coversum/893643974x_2.jpg"
      ), onTap: {}
    )
    
    RecommandCell(
      bestSellerVO: BestSellerVO(
        id: "1",
        rank: 1,
        isbn: "9788932043562",
        title: "빛과 실 - 2024 노벨문학상 수상 강연문 수록, 2024 노벨문학상 수상작가",
        author: "한강 (지은이)",
        imageURL: "https://image.aladin.co.kr/product/36101/66/coversum/893643974x_2.jpg"
      ), onTap: {}
    )
  }
}
