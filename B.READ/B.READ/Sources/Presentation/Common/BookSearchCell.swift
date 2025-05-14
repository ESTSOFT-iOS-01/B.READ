//
//  BookSearchCell.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI

struct BookSearchCell: View {
  var body: some View {
    HStack(spacing: 24) {
      Image(.exampleBook)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 58 ,height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 6))
      
      VStack(alignment: .leading, spacing: 3) {
        Text("데미안")
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
        Text("헤르만 헤세")
          .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.0)
        Text("민음사 | 2009.01.02")
          .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1.0)
      }.frame(maxWidth: .infinity, alignment: .leading)
      
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
  }
}

#Preview {
  BookSearchCell()
    .background(.gray)
}
