//
//  SearchResultView.swift
//  B.READ
//
//  Created by 김도연 on 5/16/25.
//

import SwiftUI

// MARK: - (S)SearchResultView
struct SearchResultView: View {
  @State var selectedIndex = 0
  // TODO : 스와이프 제스처로 탭 전환 기능 추가 예정
  
  let tabs = [
    TabItem(title: "도서"),
    TabItem(title: "내 기록")
  ]
  
  // TODO : VM으로 데이터 이동
  var resultBooks : [BookVO] = [
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
    BookVO(isbn: "1231231",
           coverImage: Image(.exampleBook),
           title: "데미안1",
           author: "헤르만 헤세",
           publisher: "민음사",
           publishedDate: Date()
          ),
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
  var resultRecords : [RecordVO] = [
    RecordVO(
      isbn: "1231231",
      coverImage: Image(.exampleBook),
      id: "1",
      title: "데미안",
      state: .notStart
    ),
    RecordVO(
      isbn: "1231232",
      coverImage: Image(.exampleBook),
      id: "2",
      title: "데미안",
      state: .reading,
      startDate: Date()
    ),
    RecordVO(
      isbn: "1231233",
      coverImage: Image(.exampleBook),
      id: "3",
      title: "데미안",
      state: .finished,
      startDate: Date(),
      endDate: Date()
    ),
    RecordVO(
      isbn: "1231234",
      coverImage: Image(.exampleBook),
      id: "4",
      title: "데미안",
      state: .reading,
      startDate: Date()
    ),
    RecordVO(
      isbn: "1231235",
      coverImage: Image(.exampleBook),
      id: "5",
      title: "데미안",
      state: .finished,
      startDate: Date(),
      endDate: Date()
    ),
    RecordVO(
      isbn: "1231231",
      coverImage: Image(.exampleBook),
      id: "6",
      title: "데미안",
      state: .notStart
    ),
    RecordVO(
      isbn: "1231232",
      coverImage: Image(.exampleBook),
      id: "7",
      title: "데미안",
      state: .reading,
      startDate: Date()
    ),
  ]
  
  var body: some View {
    VStack(spacing: 2) {
      TopTabBar(tabs: tabs, selectedIndex: $selectedIndex)
        .frame(height: 33)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
      
      tabContentView()
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
    }
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
  
  // MARK: - (F)tabContentView
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
  
  // TODO : 탭 전환 시 스크롤 위치 기억하게 만들기 ScrollReader?
  
  // MARK: - (F)bookTabView
  @ViewBuilder
  func bookTabView() -> some View {
    SearchListView(
      items: resultBooks,
      layoutPadding: 24,
      listPadding: 16,
      onTap: { handleBookTap(isbn: $0.isbn) },
      content: { book in
        BookSearchCell(
          coverImage: book.coverImage,
          title: book.title,
          author: book.author,
          publisher: book.publisher,
          publishedDate: book.publishedDate
        )
      }
    )
  }
  
  // MARK: - (F)myRecordTabView
  @ViewBuilder
  func myRecordTabView() -> some View {
    SearchListView(
      items: resultRecords,
      layoutPadding: 24,
      listPadding: 16,
      onTap: { handleRecordTap(id: $0.id) },
      content: { record in
        RecordSearchCell(data: record)
      }
    )
  }
  
  // MARK: - (S)SearchListView
  struct SearchListView<Data: Identifiable, Content: View>: View {
    let items: [Data]
    let layoutPadding: CGFloat
    let listPadding: CGFloat
    let onTap: (Data) -> Void
    let content: (Data) -> Content

    var body: some View {
      ScrollView {
        VStack(spacing: 0) {
          ForEach(Array(items.enumerated()), id: \.1.id) { index, item in
            content(item)
              .padding(.horizontal, layoutPadding)
              .onTapGesture {
                onTap(item)
              }

            Divider()
              .frame(height: 0.8)
              .background(Color.gray1)
              .padding(.horizontal, layoutPadding)
          }
        }
        .padding(.bottom, listPadding)
      }
    }
  }
  
  private func handleBookTap(isbn: String) {
    print("선택된 도서 ISBN: \(isbn)")
    // TODO : 화면 이동 처리 여기서
  }
  
  private func handleRecordTap(id: String) {
    print("선택된 기록 id: \(id)")
    // TODO : 화면 이동 처리 여기서
  }
}

#Preview {
  SearchResultView()
}
