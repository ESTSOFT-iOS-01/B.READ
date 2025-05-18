//
//  BookSearchCell.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI

struct BookSearchCell: View {
  
  let coverImage: Image
  let title: String
  let author: String
  let publisher: String
  let publishedDate: Date
  
  var body: some View {
    HStack(alignment: .top, spacing: 24) {
      coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 58 ,height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 2)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)
        
        Text(author)
          .foregroundStyle(.brown8)
          .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)
        Text("\(publisher) | \(publishedDate.string(format: .dotSeparated))")
          .foregroundStyle(.brown5)
          .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 4)
      
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8)
    .padding(.vertical, 16)
  }
}

//#Preview {
//  BookSearchCell(
//    coverImage: Image(.exampleBook),
//    title: "데미안",
//    author: "헤르만 헤세",
//    publisher: "민음사",
//    publishedDate: Date()
//  )
//}
