//
//  RecordSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

// MARK: - (S)RecordSearchCell
struct RecordSearchCell: View {
  let data: RecordCellVO
  
  let layoutPadding: CGFloat = 8
  
  var body: some View {
    HStack(alignment: .top, spacing: 24) {
      Group {
        if let coverImage = data.coverImage {
          coverImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 58 ,height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
        } else {
          // TODO: - 사진이 없을때, 들어갈 이미지 or 도형 추가
          Rectangle()
            .fill(.red.opacity(0.2))
        }
      } // : Group
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
  
  private func dateRangeText(for data: RecordCellVO) -> String {
    switch data.readingState {
    case .notStart:
      return ""
    case .reading:
      if let start = data.period.startDate {
        return "\(start.string(format: .dotSeparated)) ~"
      }
      return ""
    case .finished:
      if let start = data.period.startDate, let end = data.period.endDate {
        return "\(start.string(format: .dotSeparated)) ~ \(end.string(format: .dotSeparated))"
      }
      return ""
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
    memoCount: DummyData.dummyRecords[0].memoIDs.count,
    quoteCount: DummyData.dummyRecords[0].quoteIDs.count,
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
  
  RecordSearchCell(data: notStartdata)
  RecordSearchCell(data: readingdata)
  RecordSearchCell(data: finisheddata)
}
