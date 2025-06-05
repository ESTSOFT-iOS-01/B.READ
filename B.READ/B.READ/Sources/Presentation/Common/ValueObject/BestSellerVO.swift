//
//  BestSellerVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/31/25.
//

import Foundation

struct BestSellerVO: Identifiable {
  let id: String
  let rank: Int
  let isbn: String
  let title: String
  let author: String
  let imageURL: String
  
  init(id: String, rank: Int, isbn: String, title: String, author: String, imageURL: String) {
    self.id = id
    self.rank = rank
    self.isbn = isbn
    self.title = title
    self.author = author
    self.imageURL = imageURL
  }
  
  init(_ bestSeller: BestSeller) {
    self.init(
      id: UUID().uuidString,
      rank: bestSeller.rank,
      isbn: bestSeller.isbn,
      title: bestSeller.title,
      author: bestSeller.author,
      imageURL: bestSeller.coverURL
    )
  }
}


struct BestSellerListVO {
  let categoryName: String
  let bestSellers: [BestSellerVO]
}
