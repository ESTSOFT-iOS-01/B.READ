//
//  SearchButton.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

enum SearchButtonStyle {
  case barcord
  case close
  
  var iconName: String {
    switch self {
    case .barcord: return SearchConstants.Icon.barcord
    case .close: return SearchConstants.Icon.close
    }
  }
  
  var iconSize: CGFloat {
    switch self {
    case .barcord: return 22
    case .close: return 16
    }
  }
}

// MARK: - (S)SearchButton
struct SearchButton: View {
  let buttonSize : CGFloat = 48
  var style: SearchButtonStyle = .barcord
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Image(systemName: style.iconName)
        .font(.system(size: style.iconSize, weight: .regular))
        .foregroundStyle(.gray3)
        .frame(width: buttonSize, height: buttonSize)
        .roundedBackground()
    }
  }
}
