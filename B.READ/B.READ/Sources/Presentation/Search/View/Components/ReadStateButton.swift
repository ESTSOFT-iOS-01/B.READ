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
              print("\(selectedState)")
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
      .environment(\.locale, Locale(languageCode: .korean, languageRegion: .southKorea))
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
  var maxPage: Int
  var placeholder: String = "0"
  var isValid: Bool? = nil
  var onSubmit: () -> Void = { }
  
  @FocusState private var internalFocus: Bool
  
  var body: some View {
    HStack(alignment: .center, spacing: 16) {
      ZStack(alignment: .leading) {
        if page.isEmpty {
          Text(placeholder)
            .foregroundColor(.gray2)
        }
        
        TextField("", text: $page)
          .focused($internalFocus)
          .foregroundColor(.gray9)
          .frame(maxWidth: .infinity)
          .onChange(of: isFocused?.wrappedValue ?? internalFocus) { _, new in
              DispatchQueue.main.async {
                  internalFocus = new
                  isFocused?.wrappedValue = new
              }
          }
          .onChange(of: page) { _, newValue in
              let filtered = newValue.filter { $0.isNumber }
              if filtered != newValue {
                  page = filtered
              }
          }
          .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
              Spacer()
              Button("완료") {
                internalFocus = false
                isFocused?.wrappedValue = false
                onSubmit()
              }
            }
          }
      }
      .brStyleFont(.pretendard(.regular, size: 14),
                   lineHeight: 1.45,
                   letterSpacing: -0.025)
      .background(Color.gray0)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(borderColor, lineWidth: 0.8)
      )
      .animation(.easeInOut(duration: 0.15), value: borderColor)
      .frame(width: 256, height: 48)
      .padding(.horizontal, 16)
      .roundedBackground()
      
      
      Text("쪽")
        .brStyleFont(.pretendard(.medium, size: 16), lineHeight: 1.2)
        .foregroundStyle(.black)
    }
  }
  
  private var borderColor: Color {
    guard !page.isEmpty else { return .clear }
    guard let isValid = isValid else { return .clear }
    return isValid ? .brown3 : .red
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
      .tint(.gray9)
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
