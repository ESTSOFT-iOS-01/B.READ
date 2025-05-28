//
//  SentenceViewModel.swift
//  B.READ
//
//  Created by 도민준 on 2025/05/25.
//

import Foundation

/// 새 문장 작성(create) 혹은 기존 문장 수정(edit) 모드 구분
enum SentenceInputMode {
  case create(isbn: String)
  case edit(quote: Quote)
}

@MainActor
final class SentenceViewModel: ObservableObject {
  // MARK: - State
  @Published var content: String
  @Published var pageText: String
  @Published var isSubmitting: Bool = false
  @Published var errorMessage: String?
  
  // MARK: - Internal Variables
  private let mode: SentenceInputMode
  private let quoteUseCase: QuoteUseCase = QuoteUseCaseImpl(
    quoteRepository: QuoteRepositoryStub(),
    bookRepository: BookRepositoryStub()
  )
  
  // MARK: - Actions
  enum Action {
    case updateContent(String)
    case updatePageText(String)
    case submit
  }
  
  func send(_ action: Action) {
    switch action {
    case .updateContent(let newText):
      content = newText
    case .updatePageText(let newText):
      pageText = newText
    case .submit:
      performSubmit()
    }
  }
  
  // MARK: - Initializer
  init(
    mode: SentenceInputMode
  ) {
    self.mode = mode
    switch mode {
    case .create:
      self.content = ""
      self.pageText = ""
    case .edit(let quote):
      self.content = quote.content
      self.pageText = String(quote.page)
    }
  }
}

// MARK: - Private Helpers
private extension SentenceViewModel {
  func performSubmit() {
    Task {
      // 1) 내용 검증
      let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmed.isEmpty else {
        await MainActor.run { self.errorMessage = QuoteUseCaseError.emptyContent.localizedDescription }
        return
      }
      
      // 2) 페이지 숫자 변환 검증
      guard let page = Int(pageText) else {
        await MainActor.run { self.errorMessage = "페이지를 숫자로 입력해주세요." }
        return
      }
      
      // 3) 페이지 범위 검증(use case 재활용)
      let isbn: String
      switch mode {
      case .create(let bookISBN): isbn = bookISBN
      case .edit(let existing): isbn = existing.isbn
      }
      do {
        try await quoteUseCase.validatePage(page, forISBN: isbn)
      } catch {
        await MainActor.run { self.errorMessage = error.localizedDescription }
        return
      }
      
      // 4) ID 결정 및 DTO 생성
      let id: String
      switch mode {
      case .create: id = UUID().uuidString
      case .edit(let existing): id = existing.id
      }
      let model = Quote(id: id, isbn: isbn, content: trimmed, page: page)
      
      // 5) 제출 상태 갱신
      await MainActor.run {
        self.isSubmitting = true
        self.errorMessage = nil
      }
      defer {
        Task { await MainActor.run { self.isSubmitting = false } }
      }
      
      // 6) UseCase 호출
      do {
        switch mode {
        case .create:
          try await quoteUseCase.addQuote(model)
        case .edit:
          try await quoteUseCase.updateQuote(model)
        }
      } catch {
        await MainActor.run { self.errorMessage = error.localizedDescription }
      }
    }
  }
}
