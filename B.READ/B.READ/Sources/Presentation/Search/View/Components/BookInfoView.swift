//
//  BookInfoView.swift
//  B.READ
//
//  Created by 김도연 on 5/27/25.
//

import SwiftUI

// MARK: - (S)LargeImageView
struct LargeImageView: View {
  let imageURL: String
  
  var body: some View {
    AsyncImage(url: URL(string: imageURL)) { phase in
      switch phase {
      case .empty:
        ProgressView()
          .frame(width: 190, height: 290)
        
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 190, height: 290)
          .clipped()
          .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 2)
        
      case .failure(_):
        // TODO : 기본이미지 넣기
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .frame(width: 190, height: 290)
          .foregroundStyle(.brown5)
        
      @unknown default:
        EmptyView()
      }
    }
  }
}

// MARK: - (S)BookInfoView
struct BookInfoView: View {
  let layoutPadding : CGFloat = 16
  let title : String
  var content: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: layoutPadding/2) {
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
    .background(.white)
  }
}

// MARK: - (S)BookRateView
struct BookRateView: View {
  let title : String = "알라딘 평점"
  let layoutPadding : CGFloat = 16
  var count: Int
  var rate: Double
  
  var body: some View {
    VStack(alignment: .leading, spacing: layoutPadding/2) {
      HStack(spacing: 0) {
        Text("\(title)")
          .brStyleFont(.pretendard(.semiBold, size: 16), lineHeight: 1.2, letterSpacing: 0.002)
          .frame(alignment: .leading)
        
        Text("(\(count)명)")
          .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1.2, letterSpacing: 0.002)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.top, layoutPadding)

      HStack(spacing: 8) {
        ScoreBoardView(Int(rate/2), type: .star)
        
        Text(rate.toStringForOneDecimal)
          .brStyleFont(.peaceSans(size: 16), lineHeight: 1.2, letterSpacing: 0.002)
          .foregroundStyle(.orange7)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.bottom, layoutPadding)
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity)
    .frame(alignment: .leading)
    .background(.white)
  }
}

// MARK: - (S)BookTitleView
struct BookTitleView: View {
  let layoutPadding : CGFloat = 16
  let title : String
  var author: String
  var publisher: String
  var page: String
  var date: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: layoutPadding) {
      Text(title)
        .brStyleFont(.pretendard(.bold, size: 24), lineHeight: 1.3)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, layoutPadding)
      
      VStack(alignment: .leading, spacing: layoutPadding/2) {
        Text(author)
          .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.3)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("\(publisher) | \(page) 쪽 | \(date)")
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.2)
          .foregroundStyle(.gray3)
          .truncationMode(.tail)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity)
    .frame(alignment: .leading)
    .background(.white)
  }
  
}

#Preview {
  ScrollView {
    LargeImageView(imageURL: ImageURLConverter.highQualityURL(from: "https://image.aladin.co.kr/product/36292/22/coversum/8932043566_1.jpg"))
    Spacer(minLength: 40)
    BookTitleView(title: "데미안", author: "레프 니콜라예비치 톨스토이 (Lev Nikolayevich Tolstoy), 알렉산드르 세르게예비치 푸쉬킨 (Aleksandr Sergeyevich Pushkin)", publisher: "민음사", page: "234", date: "2009. 01. 02")
    
    BookRateView(count: 12, rate: 9.3)
    BookInfoView(title: "ISBN", content: "974-123-123123")
    BookInfoView(title: "상세 정보", content: "Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum. Lorem ipsum dolor sit amet consectetur. Nec neque non sit nulla elit dis morbi sem gravida. Sit semper varius leo sit amet nec ut egestas sapien. At interdum integer consequat at. Proin sit ut venenatis vestibulum maecenas at fermentum.")
  }

}
