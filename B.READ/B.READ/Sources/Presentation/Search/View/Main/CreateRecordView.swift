//
//  CreateRecordView.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import SwiftUI

struct CreateRecordView: View {
  var maxPage: Int = 100
  
  @State private var selectedState: ReadingState = .notStart
  @State var heartRate: Int = 0
  @State var starRate: Int = 0
  
  @State var startDate: Date = Date()
  @State var endDate: Date = Date()
  
  @State var page: String = ""
  @State var isFocused: Bool = false
  @State var isTextEditorFocused: Bool = false
  @State var reviewText: String = ""
  
  var action = {
    print("저장하기 버튼 눌림")
  }
  
  var body: some View {
    Group {
      VStack(alignment: .leading) {
        ReadStateSelectorView(selectedState: $selectedState)
        
        stateContentView()
          .padding(.top, 24)
          .animation(.easeInOut, value: selectedState)
        
        BottomButton(buttonTitle: "저장하기", action: action)
          .padding(.top, 24)
          .padding(.bottom, 40)
          .padding(.horizontal, 2)
      }
      .frame(maxHeight: .infinity, alignment: .bottom)
      .padding(.horizontal, 24)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      isTextEditorFocused = false
      isFocused = false
    }
  }
  
  // MARK: - (F)stateContentView
  @ViewBuilder
  private func stateContentView() -> some View {
    let layoutPadding : CGFloat = 24
    
    let submit: () -> Void  = {
      print("\(page) 페이지 입력됨")
      isFocused = false
    }
    
    let tapGesture: () -> Void  = {
      isTextEditorFocused = false
    }
    
    switch selectedState {
    case .notStart:
      SelectRateView(isStar: false, rate: $heartRate)
        .transition(.opacity)
      
    case .reading:
      VStack(alignment: .leading, spacing: 0) {
        // 독서 기간 입력
        TextHeaderView(title: "독서 기간")
        SelectDateView(selectedDate: $startDate)
          .padding(.leading, 4)
          .padding(.top, 12)
        
        // 페이지 입력
        TextHeaderView(title: "독서량")
          .padding(.top, layoutPadding)
        SelectPageView(page: $page, isFocused: $isFocused, onSubmit: submit, maxPage: maxPage)
        .padding(.leading, 4)
        .padding(.top, 12)
        
      }
      .transition(.opacity)

    case .finished:
      VStack(alignment: .leading, spacing: 0) {
        // 독서 기간 입력
        TextHeaderView(title: "독서 기간")
        HStack(spacing: 48) {
          SelectDateView(selectedDate: $startDate)
          SelectDateView(title: "종료 날짜", selectedDate: $endDate)
        }
        .padding(.leading, 4)
        .padding(.top, 12)
        
        // 평점 입력
        SelectRateView(rate: $starRate)
        .padding(.top, layoutPadding)
        
        // 리뷰 입력
        ReviewInputView(
          reviewText: $reviewText,
          isFocused: $isTextEditorFocused,
          tapGesture: tapGesture
        )
        .padding(.top, 16)
      } // : 내부 뷰 Vstack
      .transition(.opacity)
    }
  }
  
}

#Preview {
  CreateRecordView()
}
