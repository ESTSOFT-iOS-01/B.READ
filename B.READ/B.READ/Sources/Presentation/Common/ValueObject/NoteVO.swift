//
//  NoteVO.swift
//  B.READ
//
//  Created by 심근웅 on 6/7/25.
//

import Foundation
import SwiftUI

// MARK: - (S)NoteVO
struct NoteVO: Identifiable {
  let id: String
  let bookTitle: String
  let author: String
  let createdAt:Date
  let coverImage: Image?
  let content: String
  let recordId: String
  
  init(
    id: String,
    bookTitle: String,
    author: String,
    createdAt: Date,
    coverImage: Image?,
    content: String,
    recordId: String
  ) {
    self.id = id
    self.bookTitle = bookTitle
    self.author = author
    self.createdAt = createdAt
    self.coverImage = coverImage
    self.content = content
    self.recordId = recordId
  }
  
  init(record: Record, book: Book, note: AlanSummary) {
    self.id = note.id
    self.bookTitle = book.name
    self.author = book.author
    self.createdAt = note.createdAt
    if let data = book.coverImage, let uiImage = UIImage(data: data) {
      self.coverImage = Image(uiImage: uiImage)
    } else {
      self.coverImage = nil
    }
    self.content = note.content
    self.recordId = record.id
  }
}

extension NoteVO: Equatable {
  static func == (lhs: NoteVO, rhs: NoteVO) -> Bool {
    return lhs.id == rhs.id &&
    lhs.bookTitle == rhs.bookTitle &&
    lhs.author == rhs.author &&
    lhs.createdAt == rhs.createdAt &&
    lhs.coverImage == rhs.coverImage &&
    lhs.content == rhs.content &&
    lhs.recordId == rhs.recordId
  }
}
