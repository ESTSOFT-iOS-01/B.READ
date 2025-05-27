//
//  BookServiceEntity.swift
//  B.READ
//
//  Created by 김도연 on 5/23/25.
//

import Foundation

struct SearchPagnation {
  let totalCount: Int
  let startIndex: Int
  let countPerPage: Int
  let books: [BookPreview]
}

struct BookPreview {
  let title: String
  let author: String
  let publishedDate: String
  let description: String
  let isbn: String
  let coverURL: String
  let publisher: String
}

struct BookDetail {
  let title: String
  let author: String
  let publishedDate: String
  let description: String
  let isbn: String
  let coverURL: String
  let publisher: String
  let pageCount: Int
  let ratingScore: Double
  let ratingCount : Int
  let link: String
}

struct BestSeller {
  let title: String
  let author: String
  let isbn: String
  let coverURL: String
  let rank: Int
}
