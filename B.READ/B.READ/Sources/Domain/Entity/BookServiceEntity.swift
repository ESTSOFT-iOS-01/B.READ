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
  
  init(totalCount: Int, startIndex: Int, countPerPage: Int, books: [BookPreview]) {
    self.totalCount = totalCount
    self.startIndex = startIndex
    self.countPerPage = countPerPage
    self.books = books
  }
}

struct BookPreview {
  let title: String
  let author: String
  let publishedDate: String
  let description: String
  let isbn: String
  let coverURL: String
  let publisher: String
  
  init(
    title: String,
    author: String,
    publishedDate: String,
    description: String,
    isbn: String,
    coverURL: String,
    publisher: String
  ) {
    self.title = title
    self.author = author
    self.publishedDate = publishedDate
    self.description = description
    self.isbn = isbn
    self.coverURL = coverURL
    self.publisher = publisher
  }
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
  
  init(
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
}

struct BestSeller {
  let title: String
  let author: String
  let isbn: String
  let coverURL: String
  let rank: Int
  
  init(title: String, author: String, isbn: String, coverURL: String, rank: Int) {
    self.title = title
    self.author = author
    self.isbn = isbn
    self.coverURL = coverURL
    self.rank = rank
  }
}
