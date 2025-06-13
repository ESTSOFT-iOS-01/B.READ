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
  let createdAt: Date
  let coverImage: Image
  
  let record: RecordDetailVO
  let memos: [MemoVO]
  let quotes: [QuoteVO]
  
  init(note: AlanSummary, record: Record, book: Book) {
    self.id = note.id
    self.bookTitle = book.name
    self.author = book.author
    self.createdAt = note.createdAt
    if let imageData = book.coverImage, let image = UIImage(data: imageData) {
      self.coverImage = Image(uiImage: image)
    } else {
      self.coverImage = Image(.exampleCover)
    }
    
    let recordDetailVO = RecordDetailVO(record: record, book: book)
    self.record = recordDetailVO
    self.memos = record.memos.map { MemoVO($0, record: recordDetailVO) }
    self.quotes = record.quotes.map { QuoteVO($0, record: recordDetailVO) }
  }
}

extension NoteVO: Equatable {
  static func == (lhs: NoteVO, rhs: NoteVO) -> Bool {
    return lhs.id == rhs.id &&
    lhs.bookTitle == rhs.bookTitle &&
    lhs.author == rhs.author &&
    lhs.createdAt == rhs.createdAt &&
    lhs.coverImage == rhs.coverImage
  }
}
