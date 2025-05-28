//
//  QuoteListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import SwiftUI

// MARK: - (S)QuoteListView
struct QuoteListView: View {
  let quoteGroups: [QuoteGroup]
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 8) {
        
        ForEach(quoteGroups) { group in
          Section {
            ForEach(group.quotes) { quote in
              QuoteCell(content: quote.content, page: quote.page, colorTone: .soft) {
                
              }
              .padding(.leading, 8)
            }
          } header: {
            Text(group.bookTitle)
              .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(.backgroundDefault)
              .padding(.top, 24)
          }// : Section
        }
        
      } // : LazyVStack
    } // : ScrollView
    .background(.backgroundDefault)
  }
}


#Preview {
  RecordQuoteView()
}
