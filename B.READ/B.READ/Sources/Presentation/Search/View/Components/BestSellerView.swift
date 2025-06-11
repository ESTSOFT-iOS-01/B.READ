//
//  BestSellerView.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

// MARK: - (S)BestSellerView
struct BestSellerView: View {
  var bookList: [BestSellerVO]
  var onTap: (BestSellerVO) -> Void
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 8) {
        ForEach(Array(bookList.enumerated()), id: \.element.id) { index, book in
          BestSellerButton(rank: index + 1, name: book.title) {
            onTap(book)
          }
        }
      } // : Vstack
    }
  }
}

// MARK: - (S)BestSellerButton
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
          .brStyleFont(.pretendard(.regular, size: 14),
                       lineHeight: 1.2,
                       letterSpacing: 0.02)
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
