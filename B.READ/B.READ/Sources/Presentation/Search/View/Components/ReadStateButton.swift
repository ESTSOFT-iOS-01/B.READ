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

#Preview {
  ReadStateSelectorView()
}
