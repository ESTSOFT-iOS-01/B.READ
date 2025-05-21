//
//  BookDTO.swift
//  B.READ
//
//  Created by 심근웅 on 5/20/25.
//

import Foundation
import SwiftData

@Model
final class BookDTO {
  
  @Attribute(.unique) var isbn: String
  var coverImage: Data?
  var name: String
  var author: String
  var publisher: String
  var publishedAt: Date
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
  
  convenience init(_ data: Book) {
    self.init(
      isbn: data.isbn,
      coverImage: data.coverImage,
      name: data.name,
      author: data.author,
      publisher: data.publisher,
      publishedAt: data.publishedAt,
      totalPages: data.totalPages
    )
  }
}

extension BookDTO {
  func toEntity() -> Book {
    return Book(
      isbn: self.isbn,
      coverImage: self.coverImage,
      name: self.name,
      author: self.author,
      publisher: self.publisher,
      publishedAt: self.publishedAt,
      totalPages: self.totalPages
    )
  }
}
