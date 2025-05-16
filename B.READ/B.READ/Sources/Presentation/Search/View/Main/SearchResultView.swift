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
  @GestureState private var dragOffset: CGSize = .zero
  @State private var swipeDirection: Edge = .trailing
  
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
    VStack(spacing: 2) {
      TopTabBar(tabs: tabs, selectedIndex: $selectedIndex)
        .frame(height: 33)
        .padding(.horizontal, 24)
      
      tabContentView()
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
    }.background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
  
  @ViewBuilder
  func tabContentView() -> some View {
    if selectedIndex == 0 {
      bookTabView()
        .transition(.asymmetric(insertion: .move(edge: .leading),
                                removal: .opacity))
    } else {
      myRecordTabView()
        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                removal: .opacity))
    }
  }
  
  @ViewBuilder
  func bookTabView() -> some View {
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
          .onTapGesture {
            handleBookTap(isbn: book.isbn)
          }
          
          Divider()
            .frame(height: 0.8)
            .background(Color.gray1)
            .padding(.horizontal, 24)
        }
      }
      .padding(.bottom, 16)
    }
  }
  
  @ViewBuilder
  func myRecordTabView() -> some View {
    Text("내 기록은 아직 구현되지 않았어요.")
      .frame(maxHeight: .infinity, alignment: .top)
      .padding(.all, 16)
  }
  
  private func handleBookTap(isbn: String) {
    print("선택된 도서 ISBN: \(isbn)")
    // TODO : 화면 이동 처리 여기서
  }
}

#Preview {
  SearchResultView()
}
