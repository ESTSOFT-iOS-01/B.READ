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
        PropertyView(SearchConstants.Icon.heart, data.expectation.toStringForOneDecimal)
        PropertyView(SearchConstants.Icon.memo, data.memoCount.toString, .count)
        PropertyView(SearchConstants.Icon.quote, data.quoteCount.toString, .count)
      case .reading:
        PropertyView(SearchConstants.Icon.progress, data.progress.toString, .percent)
        PropertyView(SearchConstants.Icon.memo, data.memoCount.toString, .count)
        PropertyView(SearchConstants.Icon.quote, data.quoteCount.toString, .count)
      case .finished:
        PropertyView(SearchConstants.Icon.star, data.rate.toStringForOneDecimal)
        PropertyView(SearchConstants.Icon.memo, data.memoCount.toString, .count)
        PropertyView(SearchConstants.Icon.quote, data.quoteCount.toString, .count)
      }
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
