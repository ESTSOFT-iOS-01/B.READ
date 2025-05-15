//
//  BestSellerView.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

struct BestSellerView: View {
  var bookList: [String]
  var onTap: (Int, String) -> Void
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        ForEach(bookList.indices, id: \.self) { index in
          let name = bookList[index]
          BestSellerButton(rank: index + 1, name: name) {
            onTap(index + 1, name)
          }
        }
      } // : Vstack
    }
  }
}

struct BestSellerButton: View {
  let rank: Int
  let name: String
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 16) {
        Text("\(rank)")
          .brStyleFont(.peaceSans(size: 14), lineHeight: 1)
          .foregroundStyle(.brown7)
        
        Text(name)
          .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.2, letterSpacing: 0.02)
          .foregroundStyle(.brown9)
          .lineLimit(1)
          .truncationMode(.tail)
      } // : Hstack
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, alignment: .leading)
    } // : Button
    .frame(height: 48)
    .roundedBackground(color: .green1.opacity(0.8))
  }
}
