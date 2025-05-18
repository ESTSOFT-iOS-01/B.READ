//
//  RecordSearchCell.swift
//  B.READ
//
//  Created by 김도연 on 5/18/25.
//

import SwiftUI

enum ReadingState {
  case notStart
  case reading
  case finished
  
  // 상태에 따라 들어오는 타입이 다름
}

struct RecordSearchCell: View {
  var body: some View {
    HStack(spacing: 4) {
      propertyView("timer", "25%")
      propertyView("heart.fill", "2.5")
      propertyView("star.fill", "2.5")
      propertyView("archivebox", "9개")
      propertyView("note.text", "9개")
      propertyView("archivebox.fill", "9개")
      propertyView("ellipsis.bubble", "12개")
    }
  }

}

#Preview {
    RecordSearchCell()
}


@ViewBuilder
public func propertyView(_ iconName: String, _ content: String) -> some View {
  HStack(spacing: 4) {
    Image(systemName: iconName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 16, height: 16, alignment: .center)
      .background(.red.opacity(0.5))
    
    Text(content)
      .brStyleFont(.pretendard(.medium, size: 14), lineHeight: 1.0)
      .lineLimit(1)
      .truncationMode(.tail)
  }
  .foregroundStyle(.orange9)
}
