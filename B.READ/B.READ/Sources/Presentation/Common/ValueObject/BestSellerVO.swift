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
}


struct BestSellerListVO {
  let categoryName: String
  let bestSellers: [BestSellerVO]
}
