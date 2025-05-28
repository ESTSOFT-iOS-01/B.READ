//
//  CustomTextEditor.swift
//  B.READ
//
//  Created by 김도연 on 5/28/25.
//

import UIKit
import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
  @Binding var text: String
  @Binding var isFocused: Bool
  
  var placeholder: String
  var font: UIFont = .pretendard(.regular, size: 14)
  var textColor: UIColor = .gray9
  var placeholderColor: UIColor = .gray2
  var backgroundColor: UIColor = .gray0
  var maxLength: Int? = nil
  
  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.delegate = context.coordinator
    textView.isScrollEnabled = true
    textView.backgroundColor = backgroundColor
    textView.font = font
    textView.layer.cornerRadius = 8
    textView.textColor = textColor
    textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    textView.typingAttributes = makeTypingAttributes()
    
    // placeholder 초기 표시
    if text.isEmpty {
      textView.text = placeholder
      textView.textColor = placeholderColor
    }
    
    return textView
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    if isFocused != uiView.isFirstResponder {
      if isFocused {
        uiView.becomeFirstResponder()
      } else {
        uiView.resignFirstResponder()
      }
    }
    
    if uiView.isFirstResponder {
      if uiView.textColor == placeholderColor {
        uiView.text = ""
        uiView.textColor = textColor
      }
    } else {
      if text.isEmpty {
        uiView.text = placeholder
        uiView.textColor = placeholderColor
      } else {
        uiView.text = text
        uiView.textColor = textColor
      }
    }
    
    uiView.typingAttributes = makeTypingAttributes()
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(
      text: $text,
      isFocused: $isFocused,
      placeholder: placeholder,
      placeholderColor: placeholderColor,
      textColor: textColor,
      maxLength: maxLength
    )
  }
  
  private func makeTypingAttributes() -> [NSAttributedString.Key: Any] {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.2
    
    return [
      .font: font,
      .foregroundColor: textColor,
      .paragraphStyle: paragraphStyle
    ]
  }
  
  class Coordinator: NSObject, UITextViewDelegate {
    @Binding var text: String
    @Binding var isFocused: Bool
    var placeholder: String
    var placeholderColor: UIColor
    var textColor: UIColor
    let maxLength: Int?
    
    init(text: Binding<String>, isFocused: Binding<Bool>, placeholder: String, placeholderColor: UIColor, textColor: UIColor, maxLength: Int?) {
      _text = text
      _isFocused = isFocused
      self.placeholder = placeholder
      self.placeholderColor = placeholderColor
      self.textColor = textColor
      self.maxLength = maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
      if textView.textColor != placeholderColor {
        text = textView.text
      }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      $isFocused.wrappedValue = true
      if textView.text == placeholder {
        textView.text = nil
        textView.textColor = textColor
      }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      $isFocused.wrappedValue = false
      if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        textView.text = placeholder
        textView.textColor = placeholderColor
      }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool {
      guard let maxLength = maxLength else { return true }
      
      let inputString = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
      guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
      
      let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
      
      
      // 비속어 감지도 여기로
      return newString.count <= maxLength
    }
  }
}
