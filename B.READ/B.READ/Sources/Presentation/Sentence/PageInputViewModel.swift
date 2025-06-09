//
//  PageInputViewModel.swift
//  B.READ
//
//  Created by 심근웅 on 6/9/25.
//

import Foundation
import SwiftUI

final class PageInputViewModel: ObservableObject {
  // MARK: - State
  @Published var page: String = ""
  @Published private(set) var isValid: Bool
  @Published private(set) var didSubmitSuccess: Bool = false
  @Published private(set) var errorMessage: String?
  @Published var showErrorAlert: Bool = false
  
  // MARK: - Internal Variables
  private let record: RecordDetailVO
  private var quote: QuoteVO
  var sentence: String { quote.content }
  
  // MARK: - Initializer
  init(record: RecordDetailVO, quote: QuoteVO) {
    self.record = record
    self.quote = quote
    self.page = quote.page.description
    self.isValid = quote.page <= record.totalPage && quote.page > 0
  }
  
  // MARK: - Depenency
  @Dependency private var quoteUseCase: QuoteUseCase
  
  // MARK: - Actions
  enum Action {
    case updatePage
    case submit
  }
  
  func send(_ action: Action) {
    switch action {
    case .updatePage:
      self.performUpdatePage()
      
    case .submit:
      self.performSubmit()
    }
  }
}

private extension PageInputViewModel {
  /// 페이지가 업데이트 됨에 따라, isValid 업데이트
  func performUpdatePage() {
    if let page = self.page.toInt() {
      self.isValid = page > 0 && page <= self.record.totalPage
      self.quote.page = page
    }
  }
  
  /// 작성/수정한 Quote를 저장합니다.
  func performSubmit() {
    Task {
      let quote = quote.toEntity()
      let record = record.toEntity()
      
      do {
        try await quoteUseCase.saveQuote(quote, in: record)
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          showErrorAlert = true
        }
        return
      }
      
      await MainActor.run {
        errorMessage = nil
        didSubmitSuccess = true
      }
    }
  }
}
