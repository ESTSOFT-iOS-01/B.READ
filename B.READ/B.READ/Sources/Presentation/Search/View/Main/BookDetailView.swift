//
//  BookDetailView.swift
//  B.READ
//
//  Created by 김도연 on 5/22/25.
//

import SwiftUI

struct BookDetailView: View {
  @ObservedObject var viewModel: BookViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .center, spacing: 16) {
          LargeImageView(imageURL: ImageURLConverter.highQualityURL(from: viewModel.bookVO.coverURL))
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
            print("\(viewModel.bookVO.link)로 이동")
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
          viewModel.isPresentingSheet = true
        }
      )
      .padding(.horizontal, 30)
      .padding(.top, 8)
      .padding(.bottom, 16)
      
    }
    .background(.backgroundDefault)
    .sheet(isPresented: $viewModel.isPresentingSheet) {
      CreateRecordView(
        selectedState: $viewModel.selectedState
      )
      .background(.backgroundDefault, ignoresSafeAreaEdges: .bottom)
      .presentationDetents([.height(viewModel.selectedState.preferredHeight)])
      .presentationDragIndicator(.hidden)
    }
  }
}

#Preview {
  BookDetailView(viewModel: BookViewModel(isbn: "9791187011590"))
}
