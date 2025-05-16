//
//  SearchBar.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

enum SearchBarStyle {
  case `default`
  case compact
  
  var iconSize: CGFloat {
    switch self {
    case .default: return 18
    case .compact: return 14
    }
  }
  
  var iconWeight: Font.Weight {
    switch self {
    case .default: return .regular
    case .compact: return .light
    }
  }
  
  var frameSize: CGSize {
    switch self {
    case .default: return CGSize(width: 282, height: 48)
    case .compact: return CGSize(width: 275, height: 36)
    }
  }
}

// MARK: - (S)SearchBar
struct SearchBar: View {
  @Binding var text: String
  var isFocused: Binding<Bool>? = nil
  var placeholder: String = "검색어를 입력해 주세요"
  var style: SearchBarStyle = .default
  
  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: SearchConstants.Icon.search)
        .font(.system(size: style.iconSize, weight: style.iconWeight))
        .foregroundStyle(.gray2)
        .padding(.leading, 16)
      
      CustomTextField(text: $text,
                      placeholder: placeholder,
                      isFocused: isFocused)
        .padding(.trailing, 16)
    }
    .frame(width: style.frameSize.width, height: style.frameSize.height)
    .roundedBackground()
  }
}
