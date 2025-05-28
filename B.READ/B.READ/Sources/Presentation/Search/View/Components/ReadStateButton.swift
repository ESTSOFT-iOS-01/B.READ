//
//  ReadStateButton.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import SwiftUI

// MARK: - (S)ReadStateButton
struct ReadStateButton: View {
  var state: ReadingState
  var isSelected: Bool
  var onTap: () -> Void
  
  var body: some View {
    Image(state.imageName(isSelected: isSelected))
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 100)
      .contentShape(Rectangle())
      .onTapGesture {
        onTap()
      }
  }
}

// MARK: - (S)ReadStateSelectorView
struct ReadStateSelectorView: View {
  @State private var selectedState: ReadingState = .notStart
  
  var body: some View {
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

// MARK: - (S)SelectDateView
struct SelectDateView: View {
  var title: String = "시작 날짜"
  @State var selectedDate: Date = Date()
  
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

#Preview {
  ReadStateSelectorView()
  SelectDateView()
}
