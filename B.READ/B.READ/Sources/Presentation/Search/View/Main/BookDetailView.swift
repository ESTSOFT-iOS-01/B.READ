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
    Group {
      switch viewModel.bookState {
      case .loading:
        loadingView
      case .loaded(let bookDetailVO):
        loadedView(bookDetailVO)
      case .failed(let error):
        failedView(error)
      }
    }
    .background(.backgroundDefault)
    .sheet(item: $coordinator.sheet, content: { route in
      coordinator.buildView(for: route)
        .presentationDetents([.height(viewModel.selectedState.preferredHeight)])
        .presentationDragIndicator(.hidden)
    })
    .onAppear {
      viewModel.send(.onAppear)
    }
  }
  
  // MARK: - (F)loadingView
  @ViewBuilder
  private var loadingView: some View {
    ProgressView("책 데이터 불러오는 중...")
      .padding()
  }
  
  // MARK: - (F)failedView
  @ViewBuilder
  private func failedView(_ error: Error) -> some View {
    VStack(spacing: 8) {
      Text("😢 책 정보를 불러오는 데 실패했어요.")
        .font(.headline)
      Text(error.localizedDescription)
        .font(.caption)
        .foregroundColor(.gray)
    }
    .padding()
  }
  
  // MARK: - (F)loadedView
  @ViewBuilder
  private func loadedView(_ bookDetailVO: BookDetailVO) -> some View {
    VStack {
      ScrollView {
        VStack(alignment: .center, spacing: 16) {
          LargeImageView(
            imageURL: ImageURLConverter.highQualityURL(from: bookDetailVO.coverURL),
            frameSize: (190, 290)
          )
            .padding(.bottom, 24)
          
          BookTitleView(
            title: bookDetailVO.title,
            author: bookDetailVO.author,
            publisher: bookDetailVO.publisher,
            page: bookDetailVO.pageCount,
            date: bookDetailVO.publishedDate.toDotDateFormat()
          )
          
          BookRateView(count: bookDetailVO.ratingCount, rate: bookDetailVO.ratingScore)
          
          BookInfoView(title: "ISBN", content: bookDetailVO.isbn)
          BookInfoView(title: "상세 정보", content: bookDetailVO.description)
          
          Button {
            if let url = URL(string: bookDetailVO.link) {
              coordinator.push(.goToWebView(url: url))
            }
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
                page: bookDetailVO.pageCount
              )
            )
        }
      )
      .padding(.horizontal, 30)
      .padding(.top, 8)
      .padding(.bottom, 16)
    }
  }
}

//#Preview {
//  BookDetailView(viewModel: BookViewModel(isbn: "9791187011590"))
//}
