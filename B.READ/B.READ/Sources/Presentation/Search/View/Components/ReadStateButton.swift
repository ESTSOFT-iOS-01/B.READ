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
              selectedState = state
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
          .frame(minWidth: 40)
          .padding(.trailing, 2)
      } // : inner Hstack
    } // : outer Hstack
  }
}

// MARK: - (S)SelectPageView
struct SelectPageView: View {
  @Binding var page: String
  var isFocused: Binding<Bool>? = nil
  @FocusState private var internalFocus: Bool
  var onSubmit: () -> Void = { }
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
      .focused($internalFocus)
      .onChange(of: isFocused?.wrappedValue) { _, new in
        if let new = new {
          internalFocus = new
        }
      }
      .onSubmit {
        isFocused?.wrappedValue = false
        onSubmit()
      }
      
      Text("쪽")
        .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2)
        .foregroundStyle(.black)
    }
  }
}

// MARK: - (S)ReviewInputView
struct ReviewInputView: View {
  @Binding var reviewText: String
  @Binding var isFocused: Bool
  var maxLength: Int = 150
  var tapGesture: () -> Void
  let placeholderText = "짧은 감상평을 남겨보세요(선택)"

  var body: some View {
    VStack(alignment: .trailing, spacing: 4) {
      Text("\(reviewText.count)/\(maxLength)자")
        .brStyleFont(.pretendard(.light, size: 12), lineHeight: 1.2, letterSpacing: -0.02)
        .foregroundColor(.gray5)
      
      CustomTextEditor(
        text: $reviewText,
        isFocused: $isFocused,
        placeholder: placeholderText,
        maxLength: maxLength
      )
      .background(Color.clear.onTapGesture(perform: tapGesture))
      .frame(height: 100, alignment: .center)
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
