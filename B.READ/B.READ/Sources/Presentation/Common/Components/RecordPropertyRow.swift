//
//  RecordPropertyRow.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordPropertyRow
struct RecordPropertyRow: View {
  let data: RecordVO

  var body: some View {
    HStack(spacing: 12) {
      switch data.state {
      case .notStart:
        PropertyView(SFSymbol.heart.name, data.expectation.toStringForOneDecimal)
      case .reading:
        PropertyView(SFSymbol.timer.name, data.progress.toString, .percent)
      case .finished:
        PropertyView(SFSymbol.star.name, data.rate.toStringForOneDecimal)
      }
      PropertyView(SFSymbol.memo.name, data.memoCount.toString, .count)
      PropertyView(SFSymbol.bubble.name, data.quoteCount.toString, .count)
    }
  }
}

// MARK: - Preview
#Preview {
  let notStartdata = RecordVO(
    isbn: "123123",
    coverImage: Image(.exampleBook),
    id: "12",
    title: "데미안",
    state: .notStart
  )
  let readingdata = RecordVO(
    isbn: "123123",
    coverImage: Image(.exampleBook),
    id: "12",
    title: "데미안",
    state: .reading
  )
  let finisheddata = RecordVO(
    isbn: "123123",
    coverImage: Image(.exampleBook),
    id: "12",
    title: "데미안",
    state: .finished
  )
  
  RecordPropertyRow(data: notStartdata)
  RecordPropertyRow(data: readingdata)
  RecordPropertyRow(data: finisheddata)
}
