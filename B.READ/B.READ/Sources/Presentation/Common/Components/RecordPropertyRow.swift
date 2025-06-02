//
//  RecordPropertyRow.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordPropertyRow
struct RecordPropertyRow: View {
  let data: RecordCellVO

  var body: some View {
    HStack(spacing: 12) {
      switch data.readingState {
      case .notStart:
      PropertyView(SFSymbol.heart.name, data.heart.toString)
      case .reading:
        PropertyView(SFSymbol.timer.name, data.progress.toString, .percent)
      case .finished:
        PropertyView(SFSymbol.star.name, data.star.toString)
      }
      PropertyView(SFSymbol.memo.name, data.memoCount.toString, .count)
      PropertyView(SFSymbol.bubble.name, data.quoteCount.toString, .count)
    }
  }
}

// MARK: - Preview
#Preview {
  let notStartdata = RecordCellVO(
    id: DummyData.dummyRecords[0].id,
    isbn: DummyData.dummyRecords[0].isbn,
    title: DummyData.dummyBooks[0].name,
    coverImage: Image(.exampleBook),
    readingState: ReadingState.fromEntity(DummyData.dummyRecords[0].state),
    heart: DummyData.dummyRecords[0].heartCount,
    progress: 0,
    star: DummyData.dummyRecords[0].starCount,
    memoCount: DummyData.dummyRecords[0].memos.count,
    quoteCount: DummyData.dummyRecords[0].quotes.count,
    period: DummyData.dummyRecords[0].period,
    isFavorite: DummyData.dummyRecords[0].isFavorite,
    createdAt: DummyData.dummyRecords[0].createdAt
  )
  let readingdata = RecordCellVO(
    id: DummyData.dummyRecords[1].id,
    isbn: DummyData.dummyRecords[1].isbn,
    title: DummyData.dummyBooks[1].name,
    coverImage: Image(.exampleBook),
    readingState: ReadingState.fromEntity(DummyData.dummyRecords[1].state),
    heart: DummyData.dummyRecords[1].heartCount,
    progress: 65,
    star: DummyData.dummyRecords[1].starCount,
    memoCount: DummyData.dummyRecords[1].memoIDs.count,
    quoteCount: DummyData.dummyRecords[1].quoteIDs.count,
    period: DummyData.dummyRecords[1].period,
    isFavorite: DummyData.dummyRecords[1].isFavorite,
    createdAt: DummyData.dummyRecords[1].createdAt
  )
  let finisheddata = RecordCellVO(
    id: DummyData.dummyRecords[2].id,
    isbn: DummyData.dummyRecords[2].isbn,
    title: DummyData.dummyBooks[2].name,
    coverImage: Image(.exampleBook),
    readingState: ReadingState.fromEntity(DummyData.dummyRecords[2].state),
    heart: DummyData.dummyRecords[2].heartCount,
    progress: 65,
    star: DummyData.dummyRecords[2].starCount,
    memoCount: DummyData.dummyRecords[2].memoIDs.count,
    quoteCount: DummyData.dummyRecords[2].quoteIDs.count,
    period: DummyData.dummyRecords[2].period,
    isFavorite: DummyData.dummyRecords[2].isFavorite,
    createdAt: DummyData.dummyRecords[2].createdAt
  )
  
  RecordPropertyRow(data: notStartdata)
  RecordPropertyRow(data: readingdata)
  RecordPropertyRow(data: finisheddata)
}
