//
//  ListCell.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI

struct ListCell: View {
  
  let content: String
  let date: Date
  let startPage: Int
  let endPage: Int
  let action: () -> Void
  
  var body: some View {
    VStack(spacing: 8) {
      Text(content)
        .brStyleFont(.pretendard(.regular, size: 16), lineHeight: 1.3)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(spacing: 4) {
        
        Text(date.string(format: .dotSeparated))
          .foregroundStyle(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("\(startPage)쪽 ~ \(endPage)쪽")
        
        menuButton()
      }
      .foregroundStyle(.black) // TODO: Gray Scale로 바꾸기
      .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1, letterSpacing: 0.02)
      .frame(maxWidth: .infinity)
    }
    .padding(16)
    .background(.brown4.opacity(0.3))
    .clipShape(
      RoundedRectangle(cornerRadius: 16)
    )
  }
  
  // MARK: (F)menuButton
  @ViewBuilder
  private func menuButton() -> some View {
    Button {
      action()
    } label: {
      Image(systemName: "ellipsis")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 16, height: 16)
        .rotationEffect(.degrees(90))
    }
  }
}

#Preview {
  let content = """
Lorem ipsum dolor sit amet con sect etur. Aug ue po tenti au ctor faci lisi ult ric es sit in. T urpis q uis at pu lvinar ri sus ips um. T urpis q uis at pu lvinar. T urpis q uis at pu lvinar ri sus ips um. T urpis q uis at pu lvinar.
"""
  ListCell(content: content, date: Date(), startPage: 2, endPage: 4) {
    print("action")
  }
}
