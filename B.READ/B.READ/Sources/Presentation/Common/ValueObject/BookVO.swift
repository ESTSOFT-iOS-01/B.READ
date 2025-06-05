//
//  BookVO.swift
//  B.READ
//
//  Created by 심근웅 on 5/31/25.
//

import Foundation
import SwiftUI

struct BookVO: Identifiable {
  let id: String
  let isbn: String
  let coverImage: Image
  let title: String
  let author: String
  let publisher: String
  let publishedDate: Date
  
  init(
    id: String,
    isbn: String,
    coverImage: Image,
    title: String,
    author: String,
    publisher: String,
    publishedDate: Date
  ) {
    self.id = id
    self.isbn = isbn
    self.coverImage = coverImage
    self.title = title
    self.author = author
    self.publisher = publisher
    self.publishedDate = publishedDate
  }
  
  init(book: BookPreview, image: Image, pubDate: Date) {
    self.init(
      id: UUID().uuidString,
      isbn: book.isbn,
      coverImage: image,
      title: book.title,
      author: book.author,
      publisher: book.publisher,
      publishedDate: pubDate
    )
  }
}
