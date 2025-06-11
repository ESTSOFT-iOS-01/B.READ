//
//  CreateRecordView.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import SwiftUI

// MARK: - (S)CreateRecordView
struct CreateRecordView: View {
  @Binding var selectedState: ReadingState
  @StateObject var viewModel: NewRecordViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute, SheetRoute>
  
  private let layoutPadding: CGFloat = 24
  let onComplete: (_ isEdit: Bool) -> Void
  
  // MARK: - Inits
  init(state: Binding<ReadingState>, viewModel: @autoclosure @escaping () -> NewRecordViewModel) {
    self._selectedState = state
    self._viewModel = StateObject(wrappedValue: viewModel())
    self.onComplete = { _ in }
  }
  
  init(
    state: Binding<ReadingState>,
    viewModel: @autoclosure @escaping () -> NewRecordViewModel,
    onComplete: @escaping (_ isEdit: Bool) -> Void
  ) {
    self._selectedState = state
    self._viewModel = StateObject(wrappedValue: viewModel())
    self.onComplete = onComplete
  }
  
  // MARK: - body
  var body: some View {
    Group {
      ZStack(alignment: .topTrailing) {
        Button {
          coordinator.dismissSheet()
        } label: {
          Image(systemName: SFSymbol.xmark.name)
            .font(.system(size: 18, weight: .light))
            .foregroundColor(.brown8)
            .padding(.bottom, 16)
        }
        
        VStack(alignment: .leading) {
          ReadStateSelectorView(selectedState: $selectedState)
            .onChange(of: selectedState) { _, _ in
              viewModel.send(.releaseAllFocus)
            }
          
          stateContentView()
            .padding(.top, layoutPadding)
          
          BottomButton(buttonTitle: "저장하기") {
            viewModel.send(.pageSubmit(selectedState))
            
            if !viewModel.inValidPageNumber {
              if viewModel.recordVO != nil {
                viewModel.send(.updateRecord(selectedState))
              } else {
                viewModel.send(.createRecord(selectedState))
              }
            }
          }
          .padding(.top, layoutPadding)
          .padding(.horizontal, 2)
        }
        .frame(alignment: .bottom)
      }
      .padding(.horizontal, layoutPadding)
      .padding(.top, layoutPadding)
      .background(.backgroundDefault, ignoresSafeAreaEdges: .all)
      .clipShape(
        RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
      )
    }
    .ignoresSafeArea()
    .onChange(of: viewModel.isSuccess) { _, newValue in
      DispatchQueue.main.async {
        let isEdit = newValue
        onComplete(isEdit)
        coordinator.dismissSheet()
      }
    }
    .alert("저장 실패", isPresented: $viewModel.inValidPageNumber) {
      Button("확인", role: .cancel) {
        viewModel.send(.focusOnTextField)
      }
    } message: {
      Text("올바른 페이지 번호가 아닙니다.\n1 ~ \(viewModel.totalPage) 사이의 숫자를 입력해주세요")
    } //: alert
    .onDisappear {
      viewModel.send(.cancelTask)
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
          maxPage: viewModel.totalPage) {
            viewModel.send(.pageSubmit(selectedState))
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
