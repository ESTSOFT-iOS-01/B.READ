//
//  RecordSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordSearchCell
struct RecordSearchCell: View {
  let data: RecordVO
  
  let layoutPadding: CGFloat = 8

  var body: some View {
    HStack(alignment: .top, spacing: 24) {
      data.coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 58 ,height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)

      VStack(alignment: .leading, spacing: layoutPadding) {
        Text(data.title)
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)

        VStack(alignment: .leading, spacing: 4) {
          RecordPropertyRow(data: data)
          Text(dateRangeText(for: data))
            .foregroundStyle(.brown5)
            .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1.15, letterSpacing: -0.025)
            .lineLimit(1)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 4)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, layoutPadding)
    .padding(.vertical, 16)
    .background(.backgroundDefault)
  }
  
  private func dateRangeText(for data: RecordVO) -> String {
    switch data.state {
    case .notStart:
      return ""
    case .reading:
      if let start = data.startDate {
        return "\(start.string(format: .dotSeparated)) ~"
      }
      return ""
    case .finished:
      if let start = data.startDate, let end = data.endDate {
        return "\(start.string(format: .dotSeparated)) ~ \(end.string(format: .dotSeparated))"
      }
      return ""
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
    state: .reading,
    startDate: Date()
  )
  let finisheddata = RecordVO(
    isbn: "123123",
    coverImage: Image(.exampleBook),
    id: "12",
    title: "데미안",
    state: .finished,
    startDate: Date(),
    endDate: Date()
  )

  RecordSearchCell(data: notStartdata)
  RecordSearchCell(data: readingdata)
  RecordSearchCell(data: finisheddata)
}
