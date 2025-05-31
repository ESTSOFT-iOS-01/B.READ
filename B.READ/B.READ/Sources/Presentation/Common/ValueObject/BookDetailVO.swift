//
//  BookDetailVO.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

struct BookDetailVO: Identifiable {
  let id: String
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
