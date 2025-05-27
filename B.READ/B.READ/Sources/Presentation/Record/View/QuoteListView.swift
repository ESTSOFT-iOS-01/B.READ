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
      LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
        
        ForEach(quoteGroups) { group in
          Section {
            ForEach(group.quotes) { quote in
              QuoteCell(content: quote.content, page: quote.page, colorTone: .soft) {
                
              }
              .padding(.leading, 8)
            }
            
            Color.clear // 책의 마지막 문장과 다음책의 헤더 사이의 공간
              .frame(height: 16)
          } header: {
            Text(group.bookTitle)
              .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(.backgroundDefault)
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
