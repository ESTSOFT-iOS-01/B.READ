//
//  SearchButton.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

struct SearchButton: View {
  let buttonSize : CGFloat = 48
  var icon: String
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Image(systemName: icon)
        .font(.system(size: 22, weight: .regular))
        .foregroundStyle(.gray3)
        .frame(width: buttonSize, height: buttonSize)
        .roundedBackground()
    }
  }
}
