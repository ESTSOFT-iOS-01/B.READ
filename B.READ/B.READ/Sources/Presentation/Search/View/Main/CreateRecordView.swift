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
  
  @State var startDate: Date = Date()
  @State var endDate: Date = Date()
  
  @State var page: String = ""
  @State var isFocused: Bool = false
  
  var action = {
    print("저장하기 버튼 눌림")
  }
  
  var body: some View {
    Group {
      VStack(alignment: .leading) {
        ReadStateSelectorView(selectedState: $selectedState)
        
        switch selectedState {
        case .notStart:
          SelectRateView(isStar: false, rate: $heartRate)
            .padding(.top, 24)
          
        case .reading:
          TextHeaderView(title: "독서 기간")
            .padding(.top, 24)
          SelectDateView(selectedDate: $startDate)
            .padding(.leading, 4)
            .padding(.top, 12)
          
          // 쪽
          TextHeaderView(title: "독서량")
            .padding(.top, 24)
          SelectPageView(page: $page, isFocused: $isFocused, maxPage: maxPage)
          
        case .finished:
          TextHeaderView(title: "독서 기간")
            .padding(.top, 24)
          
          HStack(spacing: 48) {
            SelectDateView(selectedDate: $startDate)
            SelectDateView(title: "종료 날짜", selectedDate: $endDate)
          }
          .padding(.top, 12)
          .padding(.leading, 4)
          
          
        }
        
        BottomButton(buttonTitle: "저장하기", action: action)
          .padding(.top, 24)
          .padding(.bottom, 40)
          .padding(.horizontal, 2)
      }
      .padding(.horizontal, 24)
    }
  }
}

#Preview {
  CreateRecordView()
}
