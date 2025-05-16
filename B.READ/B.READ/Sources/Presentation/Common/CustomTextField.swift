//
//  CustomTextField.swift
//  B.READ
//
//  Created by 김도연 on 5/15/25.
//

import SwiftUI

// MARK: - (S)CustomTextField
struct CustomTextField: View {
  @Binding var text: String
  var placeholder: String
  var isFocused: Binding<Bool>? = nil
  
  @FocusState private var internalFocus: Bool
  
  var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty {
        Text(placeholder)
          .foregroundColor(.gray2)
          .background(.clear)
      }
      
      TextField("", text: $text)
        .focused($internalFocus)
        .foregroundColor(.gray9)
        .background(.clear)
        .frame(maxWidth: .infinity)
        .onChange(of: internalFocus) { _, new in
          isFocused?.wrappedValue = new
        }
        .onChange(of: isFocused?.wrappedValue) { _, new in
          if let new = new {
            internalFocus = new
          }
        }
        .onSubmit {
          isFocused?.wrappedValue = false
        }
    }
    .brStyleFont(.pretendard(.regular, size: 14),
                 lineHeight: 1.45,
                 letterSpacing: -0.025)
  }
}
