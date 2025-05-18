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
  var onSubmit: () -> Void = { }
  var placeholder: String = "검색어를 입력해 주세요"
  var style: SearchBarStyle = .default
  
  let layoutPadding: CGFloat = 16
  
  @FocusState private var internalFocus: Bool
  
  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: SearchConstants.Icon.search)
        .font(.system(size: style.iconSize, weight: style.iconWeight))
        .foregroundStyle(.gray2)
        .padding(.leading, layoutPadding)
      
      ZStack(alignment: .leading) {
        if text.isEmpty {
          Text(placeholder)
            .foregroundColor(.gray2)
        }
        
        TextField("", text: $text)
          .focused($internalFocus)
          .foregroundColor(.gray9)
          .frame(maxWidth: .infinity)
          .onChange(of: internalFocus) { _, new in
            isFocused?.wrappedValue = new
          }
          .onChange(of: isFocused?.wrappedValue) { _, new in
            if let new = new {
              internalFocus = new
            }
          }
          .onSubmit {
            isFocused?.wrappedValue = false
            onSubmit()
          }
      }
      .brStyleFont(.pretendard(.regular, size: 14),
                   lineHeight: 1.45,
                   letterSpacing: -0.025)
      .background(.clear)
      .padding(.trailing, layoutPadding)
    }
    .frame(width: style.frameSize.width, height: style.frameSize.height)
    .roundedBackground()
  }
}
