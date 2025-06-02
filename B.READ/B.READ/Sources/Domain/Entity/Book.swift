//
//  Book.swift
//  B.READ
//
//  Created by 심근웅 on 5/16/25.
//

import Foundation

/// 도서 정보입니다.
/// - isbn : ISBN
/// - coverImg : 표지
/// - name : 제목
/// - author : 작가 // TODO : 번역가, 옮김이 포함되는지 확인 필요
/// - publisher : 출판사
/// - publishedAt : 출판일
/// - totalPages: 총 페이지
struct Book: Equatable {
  let isbn: String
  var coverImage: Data?
  let name: String
  let author: String
  let publisher: String
  let publishedAt: Date
  var totalPages: Int
  
  init(
    isbn: String,
    coverImage: Data? = nil,
    name: String,
    author: String,
    publisher: String,
    publishedAt: Date,
    totalPages: Int
  ) {
    self.isbn = isbn
    self.coverImage = coverImage
    self.name = name
    self.author = author
    self.publisher = publisher
    self.publishedAt = publishedAt
    self.totalPages = totalPages
  }
}
