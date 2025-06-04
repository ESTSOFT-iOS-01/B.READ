//
//  QuoteWidgetView.swift
//  B.READ
//
//  Created by 도민준 on 6/4/25.
//


import SwiftUI
import WidgetKit

struct QuoteWidgetView: View {
  var entry: QuoteEntry
  
  var body: some View {
    HStack(spacing: 12) {
      Image("HappyBread")
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
      
      Text(entry.quote)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.4, letterSpacing: -0.025)
        .multilineTextAlignment(.center)
        .padding()
    }
  }
}

#Preview {
  QuoteWidgetView(entry: .init(date: Date(), quote: "Hello, World!"))
}
