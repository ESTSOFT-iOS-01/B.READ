//
//  MemoListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import SwiftUI

// MARK: - (S)MemoListView
struct MemoListView: View {
  let memoGroups: [MemoGroup]
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 8) {
        
        ForEach(memoGroups) { group in
          Section {
            ForEach(group.memos) { memo in
              MemoCell(
                content: memo.content,
                date: memo.createdAt,
                startPage: memo.pages.0,
                endPage: memo.pages.1
              ) {
                
              }
              .padding(.leading, 8)
            }

            Color.clear // 책의 마지막 메모와 다음책의 헤더 사이의 공간
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
  RecordMemoView()
}
