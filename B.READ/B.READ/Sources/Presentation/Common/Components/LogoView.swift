//
//  LogoView.swift
//  B.READ
//
//  Created by 신승재 on 6/9/25.
//

import SwiftUI

struct LogoView: View {
  var body: some View {
    Image(.topLogo)
      .resizable()
      .renderingMode(.template)
      .aspectRatio(contentMode: .fit)
      .foregroundColor(.orange3)
      .frame(height: 25)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 8)
      .padding(.leading, 24)
  }
}
