//
//  SearchResultView.swift
//  B.READ
//
//  Created by 김도연 on 5/16/25.
//

import SwiftUI

struct BookVO {
  let isbn: String
  let coverImage: Image
  let title: String
  let author: String
  let publisher: String
  let publishedDate: Date
}

struct SearchResultView: View {
  @State var selectedIndex = 0
  let tabs = [
    TabItem(title: "도서"),
    TabItem(title: "내 기록")
  ]
  
  var resultBook : [BookVO] = [
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231232",
           coverImage: Image(.exampleBook),
           title: "데미안2",
           author: "헤르만 헤세zzzz",
           publisher: "민음사zzzzzzzdsadsadadsadasdasdas",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231233",
           coverImage: Image(.exampleBook),
           title: "데미안3",
           author: "헤르만 헤세zz",
           publisher: "민음사",
           publishedDate: Date()
          ),
  ]
  
  var body: some View {
    VStack() {
      TopTabBar(tabs: tabs, selectedIndex: $selectedIndex)
        .frame(height: 30)
        .padding(.horizontal, 24)

      if selectedIndex == 0 {
        ScrollView {
          LazyVStack(spacing: 0) {
            ForEach(resultBook.indices, id: \.self) { index in
              let book = resultBook[index]

              BookSearchCell(
                coverImage: book.coverImage,
                title: book.title,
                author: book.author,
                publisher: book.publisher,
                publishedDate: book.publishedDate
              )
              .padding(.horizontal, 24)
              .padding(.top, index == 0 ? 16 : 0)
              // 그림자 안 잘리게 첫번째 항목에만 padding 추가
              
              if index < resultBook.count - 1 {
                Divider()
                  .frame(width: .infinity, height: 0.8)
                  .background(.gray1)
                  .padding(.horizontal, 24)
              }
            }
          }
          .frame(alignment: .top)
        }
      } else {
        // 내 기록 목록
        Text("내 기록은 아직 구현되지 않았어요.")
          .frame(maxHeight: .infinity, alignment: .top)
          .padding(.all, 16)
      }
    }.background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
}

#Preview {
  SearchResultView()
}
