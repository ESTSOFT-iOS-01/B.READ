//
//  BookDetailView.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import SwiftUI

// MARK: - (S)BookDetailView
struct BookDetailView: View {
  @StateObject var viewModel: BookViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  init(viewModel: BookViewModel) {
    self._viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .center, spacing: 16) {
          LargeImageView(
            imageURL: ImageURLConverter.highQualityURL(from: viewModel.bookVO.coverURL),
            frameSize: (190, 290)
          )
            .padding(.bottom, 24)
          
          BookTitleView(
            title: viewModel.bookVO.title,
            author: viewModel.bookVO.author,
            publisher: viewModel.bookVO.publisher,
            page: viewModel.bookVO.pageCount,
            date: viewModel.bookVO.publishedDate.toDotDateFormat()
          )
          
          BookRateView(count: viewModel.bookVO.ratingCount, rate: viewModel.bookVO.ratingScore)
          
          BookInfoView(title: "ISBN", content: viewModel.bookVO.isbn)
          BookInfoView(title: "상세 정보", content: viewModel.bookVO.description)
          
          Button {
            coordinator.push(.goToWebView(url: URL(string: viewModel.bookVO.link)!))
          } label: {
            LinkView()
          }
          .padding(.bottom, 40)
          
        }
      }
      .scrollIndicators(.hidden)
      
      BottomButton(
        buttonTitle: "내 책빵에 저장하기",
        action: {
          coordinator
            .presentSheet(
              .createRecord(
                state: $viewModel.selectedState,
                page: viewModel.bookVO.pageCount
              )
            )
        }
      )
      .padding(.horizontal, 30)
      .padding(.top, 8)
      .padding(.bottom, 16)
      
    }
    .background(.backgroundDefault)
    .sheet(item: $coordinator.sheet, content: { route in
      coordinator.buildView(for: route)
        .presentationDetents([.height(viewModel.selectedState.preferredHeight)])
        .presentationDragIndicator(.hidden)
    })
  }
}

#Preview {
  BookDetailView(viewModel: BookViewModel(isbn: "9791187011590"))
}
