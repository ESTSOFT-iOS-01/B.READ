//
//  RecordSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

struct RecordSearchCell: View {
  let data: RecordVO

  var body: some View {
    HStack(alignment: .top, spacing: 24) {
      data.coverImage
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 58 ,height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 2)
      
      VStack(alignment: .leading, spacing: 8) {
        Text(data.title)
          .foregroundStyle(.gray9)
          .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
          .lineLimit(1)
          .truncationMode(.tail)
        
        VStack(alignment: .leading, spacing: 4) {
          properties(data.state)
          Text("2024. 12. 12 ~")
            .foregroundStyle(.brown5)
            .brStyleFont(.pretendard(.regular, size: 12), lineHeight: 1.0, letterSpacing: -0.025)
            .lineLimit(1)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 4)
      
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 8)
    .padding(.vertical, 16)
  }
  
  @ViewBuilder
  func properties(_ readingState: ReadingState) -> some View {
    switch readingState {
    case .notStart:
      HStack(spacing: 12) {
        propertyView(SearchConstants.Icon.heart, data.expectation.toStringForOneDecimal)
        propertyView(SearchConstants.Icon.memo, data.memoCount.toString, .count)
        propertyView(SearchConstants.Icon.quote, data.quoteCount.toString, .count)
      }
    case .reading:
      HStack(spacing: 12) {
        propertyView(SearchConstants.Icon.progress, data.progress.toString, .percent)
        propertyView(SearchConstants.Icon.memo, data.memoCount.toString, .count)
        propertyView(SearchConstants.Icon.quote, data.quoteCount.toString, .count)
      }
    case .finished:
      HStack(spacing: 12) {
        propertyView(SearchConstants.Icon.star, data.rate.toStringForOneDecimal)
        propertyView(SearchConstants.Icon.memo, data.memoCount.toString, .count)
        propertyView(SearchConstants.Icon.quote, data.quoteCount.toString, .count)
      }
    }
  }
  
  
}

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
  
  VStack {
    RecordSearchCell(data: notStartdata)
    RecordSearchCell(data: readingdata)
    RecordSearchCell(data: finisheddata)
  }
  
}


@ViewBuilder
public func propertyView(_ iconName: String, _ content: String, _ unit: UnitType = .default) -> some View {
  HStack(spacing: 4) {
    Image(systemName: iconName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 12, height: 12, alignment: .center)
    
    Text(content+unit.expression)
      .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.15, letterSpacing: -0.025)
      .lineLimit(1)
      .truncationMode(.tail)
  }
  .foregroundStyle(.orange9)
}


public enum UnitType {
  case `default`
  case count
  case percent
  
  var expression: String {
    switch self {
    case .count:
      return "개"
    case .percent:
      return "%"
    default:
      return ""
    }
  }
}
