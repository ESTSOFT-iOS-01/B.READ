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
        BouncingImageLoadingView()
      case .loaded(let bookDetailVO):
        loadedView(bookDetailVO)
      case .failed(let error):
        FailedView(error: error)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      }
    }
    .sheet(item: $coordinator.sheet, content: { route in
      coordinator.buildView(for: route)
        .presentationDetents([.height(viewModel.selectedState.preferredHeight)])
        .presentationDragIndicator(.hidden)
    })
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
    .onAppear {
      viewModel.send(.onAppear)
    }
    .onDisappear {
      viewModel.send(.cancelTask)
    }
    .alert("저장 성공", isPresented: $viewModel.isSuccess) {
      Button("확인", role: .cancel) {
        DispatchQueue.main.async {
          viewModel.isSuccess = false
        }
      }
    } message: {
      Text("내 책빵에 저장되었습니다.")
    }
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
          // 책 정보가 있을 때만 생성 가능
          if let book = viewModel.currentBook {
            coordinator.presentSheet(
              .createRecord(
                state: $viewModel.selectedState,
                book: book,
                onComplete: { isSuccess in
                  if isSuccess {
                    DispatchQueue.main.async {
                      viewModel.isSuccess = true
                    }
                  }
                }
              )
            )
          } else {
            // alertpopup?
          }
        }
      )
      .padding(.horizontal, 30)
      .padding(.top, 8)
      .padding(.bottom, 16)
    }
    .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
  }
}

//#Preview {
//  BookDetailView(viewModel: BookViewModel(isbn: "9791187011590"))
//}
