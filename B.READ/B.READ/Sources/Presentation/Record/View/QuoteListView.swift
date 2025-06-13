//
//  QuoteListView.swift
//  B.READ
//
//  Created by 심근웅 on 5/27/25.
//

import SwiftUI

// MARK: - (S)QuoteListView
struct QuoteListView: View {
  @EnvironmentObject private var coordinator: Coordinator<MainRoute, SheetRoute>
  @ObservedObject var viewModel: RecordQuoteViewModel
  @State private var showMenuActionSheet = false
  @State private var showDeleteAlert = false
  
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 8) {
        
        ForEach($viewModel.displayQuoteGroups) { $group in
          Section {
            ForEach($group.quotes) { $quote in
              QuoteCell(
                content: quote.content,
                highlight: viewModel.highlightKeyword,
                page: quote.page,
                colorTone: ColorTone.tone(isbn: quote.isbn)
              ) {
                showMenuActionSheet = true
                viewModel.selectedQuote = quote
              }
              .padding(.leading, 8)
            }
          } header: {
            Group {
              if let keyword = viewModel.highlightKeyword, !keyword.isEmpty {
                group.bookTitle.highlightedText(
                  keyword: keyword,
                  regularFont: Font(UIFont.pretendard(.semiBold, size: 18)),
                  highlightFont: Font(UIFont.pretendard(.semiBold, size: 18))
                )
              } else {
                Text(group.bookTitle)
              }
            }
            .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.backgroundDefault)
            .padding(.top, 16)
          }// : Section
        }
      } // : LazyVStack
      .padding(.bottom, 40)
    } // : ScrollView
    .background(.backgroundDefault)
    .confirmationDialog(
      "메뉴를 선택하세요",
      isPresented: $showMenuActionSheet,
      titleVisibility: .hidden
    ) {
      menuActionSheet()
    } // : confirmationDialog
    .alert("문장 삭제", isPresented: $showDeleteAlert) {
      Button("삭제", role: .destructive) {
        guard let quote = viewModel.selectedQuote else { return }
        viewModel.send(.deleteQuote(id: quote.id))
      }
      Button("취소", role: .cancel) { }
    } message: {
      Text("정말로 문장을 삭제하시겠습니까?")
    } // : alert
  }
  
  // TODO: - [시르]액션 시트 tintColor systemblue 적용하기
  // MARK: - (F)menuActionSheet
  @ViewBuilder
  private func menuActionSheet() -> some View {
    Button("문장 수정") {
      guard let quote = viewModel.selectedQuote else { return }
      coordinator.push(.sentenceInput(mode: .edit(record: quote.record, quote: quote)))
    }
    
    Button("문장 삭제", role: .destructive) {
      showDeleteAlert = true
    }
    
    Button("취소", role: .cancel) { }
  }
}


#Preview {
  @Previewable @StateObject var viewModel = RecordQuoteViewModel()
  PreviewableContainer {
    QuoteListView(viewModel: viewModel)
      .onAppear {
        viewModel.send(.onAppear)
      }
  }
}
