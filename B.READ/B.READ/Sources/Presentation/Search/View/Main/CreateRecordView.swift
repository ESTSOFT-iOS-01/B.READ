//
//  CreateRecordView.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import SwiftUI

// MARK: - (S)CreateRecordView
struct CreateRecordView: View {
  private let layoutPadding: CGFloat = 24
  
  @Binding var selectedState: ReadingState
  @StateObject var viewModel: NewRecordViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  init(state: Binding<ReadingState>, viewModel: NewRecordViewModel) {
    self._selectedState = state
    self._viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    Group {
      ZStack(alignment: .topTrailing) {
        Button {
          coordinator.dismissSheet()
        } label: {
          Image(systemName: SearchConstants.Icon.close)
            .font(.system(size: 18, weight: .light))
            .foregroundColor(.brown8)
            .padding(.bottom, 16)
        }
        
        VStack(alignment: .leading) {
          ReadStateSelectorView(selectedState: $selectedState)
            .onChange(of: selectedState) { _, _ in
              viewModel.isFocused = false
              viewModel.isTextEditorFocused = false
            }
          
          stateContentView()
            .padding(.top, layoutPadding)
          
          BottomButton(buttonTitle: "저장하기") {
            viewModel.send(.onSubmit)
            // TODO : callback함수로 부모뷰에 영향끼치는 flag 하나 넘겨줘야한다.
            if viewModel.isSuccess { coordinator.dismissSheet() }
          }
          .padding(.top, layoutPadding)
          .padding(.horizontal, 2)
        }
        .frame(alignment: .bottom)
      }
      //      .animation(.easeOut(duration: 1), value: selectedState)
      .padding(.horizontal, layoutPadding)
      .padding(.top, layoutPadding)
      .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
      .clipShape(
        RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
      )
      
    }
    .ignoresSafeArea()
    .contentShape(Rectangle())
    .onTapGesture {
      viewModel.isTextEditorFocused = false
      viewModel.isFocused = false
    }
  }
  
  // MARK: - (F)stateContentView
  @ViewBuilder
  private func stateContentView() -> some View {
    
    switch selectedState {
    case .notStart:
      SelectRateView(isStar: false, rate: $viewModel.heartRate)
      
    case .reading:
      VStack(alignment: .leading, spacing: 0) {
        // 독서 기간 입력
        TextHeaderView(title: "독서 기간")
        SelectDateView(selectedDate: $viewModel.startDate)
          .topLeadingPadding()
        
        // 페이지 입력
        TextHeaderView(title: "독서량")
          .padding(.top, layoutPadding)
        SelectPageView(
          page: $viewModel.page,
          isFocused: $viewModel.isFocused,
          maxPage: viewModel.maxPage) {
            viewModel.send(.pageSubmit)
          }
          .topLeadingPadding()
      }
      
    case .finished:
      VStack(alignment: .leading, spacing: 0) {
        // 독서 기간 입력
        TextHeaderView(title: "독서 기간")
        HStack(spacing: 48) {
          SelectDateView(selectedDate: $viewModel.startDate)
          SelectDateView(title: "종료 날짜", selectedDate: $viewModel.endDate)
        }
        .topLeadingPadding()
        
        // 평점 입력
        SelectRateView(rate: $viewModel.starRate)
          .padding(.top, layoutPadding)
        
        // 리뷰 입력
        ReviewInputView(
          reviewText: $viewModel.reviewText,
          isFocused: $viewModel.isTextEditorFocused,
          maxLength: 150) {
            viewModel.send(.releaseEditorFocus)
          }
          .padding(.top, 16)
      } // : 내부 뷰 Vstack
    }
  }
  
}

#Preview {
  Spacer()
  BookDetailView(viewModel: BookViewModel(isbn: "9791187011590"))
}

extension View {
  func topLeadingPadding() -> some View {
    self
      .padding(.leading, 4)
      .padding(.top, 12)
  }
}
