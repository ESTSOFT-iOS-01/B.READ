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
  
  init(
    id: String,
    title: String,
    author: String,
    publishedDate: String,
    description: String,
    isbn: String,
    coverURL: String,
    publisher: String,
    pageCount: Int,
    ratingScore: Double,
    ratingCount: Int,
    link: String
  ) {
    self.id = id
    self.title = title
    self.author = author
    self.publishedDate = publishedDate
    self.description = description
    self.isbn = isbn
    self.coverURL = coverURL
    self.publisher = publisher
    self.pageCount = pageCount
    self.ratingScore = ratingScore
    self.ratingCount = ratingCount
    self.link = link
  }
  
  init(_ book: BookDetail) {
    self.init(
      id: UUID().uuidString,
      title: book.title,
      author: book.author,
      publishedDate: book.publishedDate,
      description: book.description,
      isbn: book.isbn,
      coverURL: book.coverURL,
      publisher: book.publisher,
      pageCount: book.pageCount,
      ratingScore: book.ratingScore,
      ratingCount: book.ratingCount,
      link: book.link
    )
  }
}
