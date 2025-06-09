//
//  QuoteCell.swift
//  B.READ
//
//  Created by 신승재 on 5/14/25.
//

import SwiftUI

enum ColorTone {
  case soft
  case regular
  
  var color: Color {
    switch self {
    case .soft:
        .green1
    case .regular:
        .green2
    }
  }
  
  static func tone(isbn: String) -> ColorTone {
    let hash = abs(isbn.hash)
    let tones: [ColorTone] = [.soft, .regular]
    return tones[hash % tones.count]
  }
}

struct QuoteCell: View {
  
  let content: String
  let highlight: String?
  let page: Int
  let colorTone: ColorTone
  let action: (() -> Void)?
  
  init(
    content: String,
    highlight: String? = nil,
    page: Int,
    colorTone: ColorTone,
    action: (() -> Void)? = nil
  ) {
    self.content = content
    self.highlight = highlight
    self.page = page
    self.colorTone = colorTone
    self.action = action
  }
  
  var body: some View {
    VStack(spacing: 8) {
      Group {
        if let keyword = self.highlight, !keyword.isEmpty {
          content.highlightedText(keyword: keyword)
        }
        else {
          Text(content)
            .font(Font(UIFont.pretendard(.regular, size: 16)))
            .foregroundColor(.black)
        }
      }
      .brStyle(.pretendard(.regular, size: 16), lineHeight: 1.3)
      .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(spacing: 4) {
        Text("\(page)쪽")
          .foregroundStyle(.gray7)
        if action != nil { menuButton() }
      }
      .brStyleFont(.pretendard(.light, size: 14), lineHeight: 1, letterSpacing: 0.02)
      .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 17.5)
    .background(colorTone.color)
    .clipShape(
      RoundedCorner(radius: 24, corners: [.topLeft, .bottomLeft, .bottomRight])
    )
  }
  
  // MARK: (F)menuButton
  @ViewBuilder
  private func menuButton() -> some View {
    Button {
      action?()
    } label: {
      Image(systemName: SFSymbol.ellipsis.name)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 16, height: 16)
        .rotationEffect(.degrees(90))
    }
    .foregroundStyle(.gray7)
  }
}

#Preview {
  let content = """
가나다라마문장을 캡쳐해볼게요. 이건 제가 수집한 문장이에요ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ
"""
  QuoteCell(content: content, page: 28, colorTone: .regular) {
    print("action")
  }
  QuoteCell(content: content, highlight: "가나다라마", page: 28, colorTone: .regular)
  QuoteCell(content: content, highlight: "수집한", page: 28, colorTone: .soft)
}
