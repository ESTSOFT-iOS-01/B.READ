//
//  ReadStateButton.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import SwiftUI

struct TextHeaderView: View {
  var title: String
  var content: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .brStyleFont(.pretendard(.semiBold, size: 18), lineHeight: 1.2)
        .foregroundStyle(.black)
      
      if let content {
        Text(content)
          .brStyleFont(.pretendard(.light, size: 12), lineHeight: 1.2, letterSpacing: -0.02)
          .foregroundStyle(.gray5)
      }
    }
  }
}

// MARK: - (S)ReadStateButton
struct ReadStateButton: View {
  var state: ReadingState
  var isSelected: Bool
  var onTap: () -> Void
  
  var body: some View {
    Image(state.imageName(isSelected: isSelected))
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 110)
      .contentShape(Rectangle())
      .onTapGesture {
        onTap()
      }
  }
}

// MARK: - (S)ReadStateSelectorView
struct ReadStateSelectorView: View {
  @Binding var selectedState: ReadingState
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      TextHeaderView(title: "굽기 정도", content: "책을 어디까지 읽으셨나요?")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(spacing: 16) {
        ForEach(ReadingState.allCases, id: \.self) { state in
          ReadStateButton(
            state: state,
            isSelected: selectedState == state,
            onTap: {
              withAnimation(.easeInOut(duration: 0.2)) {
                selectedState = state
              }
            }
          )
        }
      }
    }
  }
}

// MARK: - (S)SelectDateView
struct SelectDateView: View {
  var title: String = "시작 날짜"
  @Binding var selectedDate: Date
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .brStyleFont(.pretendard(.regular, size: 14), lineHeight: 1.2)
        .foregroundStyle(.black)
      
      DatePicker(
        "",
        selection: $selectedDate,
        displayedComponents: [.date]
      )
      .labelsHidden()
      .datePickerStyle(.compact)
    }
  }
}

// MARK: - (S)SelectRateView
struct SelectRateView: View {
  var isStar: Bool = true
  @Binding var rate: Int
  
  var body: some View {
    HStack {
      TextHeaderView(title: isStar ? "평점 및 한줄평" : "기대 지수")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(alignment: .center, spacing: 8) {
        ScoreBoardView($rate, type: isStar ? .star : .heart)
        
        Text(Double(rate).toStringForOneDecimal)
          .brStyleFont(.peaceSans(size: 16), lineHeight: 1.2, letterSpacing: 0.02)
          .foregroundStyle(.orange7)
      } // : inner Hstack
    } // : outer Hstack
  }
}

// MARK: - (S)SelectPageView
struct SelectPageView: View {
  @Binding var page: String
  var isFocused: Binding<Bool>? = nil
  @FocusState private var isFocus: Bool
  var maxPage: Int
  
  var body: some View {
    HStack(alignment: .center, spacing: 16) {
      RoundedTextField(
        type: .pages,
        placeholder: "0",
        text: $page,
        isValid: true
      )
      .frame(width: 256)
      .focused($isFocus)
      
      Text("쪽")
        .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2)
        .foregroundStyle(.black)
    }
  }
}

#Preview {
  
//  ReadStateSelectorView()
//  SelectDateView()
//  SelectRateView()
//  SelectRateView(isStar: false)
//  SelectPageView(maxPage: 300)
}
