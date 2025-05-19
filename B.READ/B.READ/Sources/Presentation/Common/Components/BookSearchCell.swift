//
//  BookSearchCell.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI

struct BookSearchCell: View {
  let data: BookVO
  
  var body: some View {
    HStack(alignment: .top, spacing: 24) {
      data.coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 58 ,height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(data.title)
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)
        
        Text(data.author)
          .foregroundStyle(.brown8)
          .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.15)
          .lineLimit(1)
          .truncationMode(.tail)
        Text("\(data.publisher) | \(data.publishedDate.string(format: .dotSeparated))")
          .foregroundStyle(.brown5)
          .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1.15, letterSpacing: -0.025)
          .lineLimit(1)
          .truncationMode(.tail)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 4)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8)
    .padding(.vertical, 16)
    .background(.backgroundDefault)
  }
}

//#Preview {
//  let dummy = BookVO(
//    isbn: "1234567890",
//    coverImage: Image(.exampleBook),
//    title: "데미안",
//    author: "헤르만 헤세",
//    publisher: "민음사",
//    publishedDate: Date()
//  )
//  BookSearchCell(data: dummy)
//  BookSearchCell(data: dummy)
//  BookSearchCell(data: dummy)
//}
