//
//  CreateRecordView.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import SwiftUI

struct CreateRecordView: View {
  @StateObject var viewModel: NewRecordViewModel
  @EnvironmentObject var coordinator: Coordinator<MainRoute>
  
  init(viewModel: NewRecordViewModel) {
    self._viewModel = .init(wrappedValue: viewModel)
  }
  
  var body: some View {
    Group {
      ZStack(alignment: .topTrailing) {
        Button {
          print("창 닫기")
        } label: {
          Image(systemName: SearchConstants.Icon.close)
            .font(.system(size: 18, weight: .light))
            .foregroundColor(.brown8)
            .padding(.bottom, 16)
        }
        
        VStack(alignment: .leading) {
          ReadStateSelectorView(selectedState: $viewModel.selectedState)
          
          stateContentView()
            .padding(.top, 24)
          
          BottomButton(buttonTitle: "저장하기", action: action)
            .padding(.top, 24)
            .padding(.horizontal, 2)
        }
        .frame(alignment: .bottom)
      }
//      .animation(.easeOut(duration: 1), value: selectedState)
      .padding(.horizontal, 24)
      .padding(.top, 24)
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
    let layoutPadding : CGFloat = 24
    
    let submit: () -> Void  = {
      print("\(viewModel.page) 페이지 입력됨")
      viewModel.isFocused = false
    }
    
    let tapGesture: () -> Void  = {
      viewModel.isTextEditorFocused = false
    }
    
    switch viewModel.selectedState {
    case .notStart:
      SelectRateView(isStar: false, rate: $viewModel.heartRate)
      
    case .reading:
      VStack(alignment: .leading, spacing: 0) {
        // 독서 기간 입력
        TextHeaderView(title: "독서 기간")
        SelectDateView(selectedDate: $viewModel.startDate)
          .padding(.leading, 4)
          .padding(.top, 12)
        
        // 페이지 입력
        TextHeaderView(title: "독서량")
          .padding(.top, layoutPadding)
        SelectPageView(page: $viewModel.page, isFocused: $viewModel.isFocused, onSubmit: submit, maxPage: viewModel.maxPage)
          .padding(.leading, 4)
          .padding(.top, 12)
        
      }
      
    case .finished:
      VStack(alignment: .leading, spacing: 0) {
        // 독서 기간 입력
        TextHeaderView(title: "독서 기간")
        HStack(spacing: 48) {
          SelectDateView(selectedDate: $viewModel.startDate)
          SelectDateView(title: "종료 날짜", selectedDate: $viewModel.endDate)
        }
        .padding(.leading, 4)
        .padding(.top, 12)
        
        // 평점 입력
        SelectRateView(rate: $viewModel.starRate)
          .padding(.top, layoutPadding)
        
        // 리뷰 입력
        ReviewInputView(
          reviewText: $viewModel.reviewText,
          isFocused: $viewModel.isTextEditorFocused,
          tapGesture: tapGesture
        )
        .padding(.top, 16)
      } // : 내부 뷰 Vstack
    }
  }
  
}

#Preview {
  Spacer()
  CreateRecordView(viewModel: NewRecordViewModel())
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
