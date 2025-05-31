//
//  SentenceViewModel.swift
//  B.READ
//
//  Created by 도민준 on 2025/05/25.
//

import Foundation

/// 새 문장 작성(create) 혹은 기존 문장 수정(edit) 모드 구분
enum SentenceInputMode: Hashable {
  case create(isbn: String)
  case edit(quote: Quote)
}

@MainActor
final class SentenceViewModel: ObservableObject {
  // MARK: - State
  @Published var content: String
  @Published var page: Int?
  @Published var maxPage: Int?
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
    case updatePage(Int?)
    case submit
  }
  
  func send(_ action: Action) {
    switch action {
    case .updateContent(let newText):
      content = newText
    case .updatePage(let newPage):
      page = newPage
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
    case .create(let isbn):
      self.content = ""
      self.page = 0
      Task { await loadMaxPage(isbn) }
      
    case .edit(let quote):
      self.content = quote.content
      self.page = quote.page
      Task { await loadMaxPage(quote.isbn) }
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
      guard let page = page else {
        await MainActor.run { self.errorMessage = "페이지를 숫자로 입력해주세요." }
        return
      }
      
      // 3) 로컬 범위 검증 (1…maxPage)
      if let limit = maxPage, !(1...limit).contains(page) {
        await MainActor.run { self.errorMessage = "페이지는 1-\(limit) 사이여야 합니다." }
        return                                   // 서버/저장소 호출 전 즉시 종료
      }
      
      // 4) 최종 범위 검증 (UseCase로 double-check)
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
      
      // 5) ID 결정 및 DTO 생성
      let id: String
      switch mode {
      case .create: id = UUID().uuidString
      case .edit(let existing): id = existing.id
      }
      let model = Quote(id: id, isbn: isbn, content: trimmed, page: page)
      
      // 6) 제출 상태 갱신
      await MainActor.run {
        self.isSubmitting = true
        self.errorMessage = nil
      }
      defer {
        Task { await MainActor.run { self.isSubmitting = false } }
      }
      
      // 7) UseCase 호출
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
  
  private func loadMaxPage(_ isbn: String) async {
    do {
      let total = try await quoteUseCase.pageCount(forISBN: isbn)
      await MainActor.run {
        self.maxPage = total
      }
    } catch {
      await MainActor.run {
        self.errorMessage = error.localizedDescription
      }
    }
  }
}
