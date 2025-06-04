//
//  SentenceViewModel.swift
//  B.READ
//
//  Created by 도민준 on 2025/05/25.
//

import Foundation

/// 새 문장 작성(create) 혹은 기존 문장 수정(edit) 모드 구분
enum SentenceInputMode: Hashable {
  case create(record: RecordDetailVO)
  case edit(record: RecordDetailVO, quote: QuoteVO)
}

@MainActor
final class SentenceViewModel: ObservableObject {
  // MARK: - State
  @Published var content: String
  @Published var page: Int?
  @Published var maxPage: Int?
  @Published var isSubmitting: Bool = false
  @Published var errorMessage: String?
  @Published var didSubmitSuccess: Bool = false
  
  // MARK: - Internal Variables
  private let mode: SentenceInputMode
  private let record: RecordDetailVO
  
  // MARK: - Depenency
  @Dependency private var quoteUseCase: QuoteUseCase
  
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
  init(mode: SentenceInputMode) {
    self.mode = mode
    switch mode {
    case .create(let record):
      self.content = ""
      self.page = nil
      self.record = record
      self.maxPage = record.totalPage
      
    case .edit(let record, let quote):
      self.content = quote.content
      self.page = quote.page
      self.record = record
      self.maxPage = record.totalPage
    }
  }
}


// MARK: - Private Helpers
private extension SentenceViewModel {
  func performSubmit() {
    didSubmitSuccess = false
    
    Task {
      // 1) 내용 검증
      let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmed.isEmpty else {
        print("[⚠️] 내용 검증 실패: 빈 문자열")
        await MainActor.run {
          self.errorMessage = QuoteUseCaseError.emptyContent.localizedDescription
        }
        return
      }
      print("[✅] 내용 검증 통과: '\(trimmed)'")
      
      // 2) 페이지 숫자 변환 검증
      guard let page = page else {
        print("[⚠️] 숫자 변환 실패: page is nil")
        await MainActor.run {
          self.errorMessage = "페이지를 숫자로 입력해주세요."
        }
        return
      }
      print("[✅] 숫자 변환 통과: page = \(page)")
      
      // 3) 로컬 범위 검증 (1…maxPage)
      if let limit = maxPage, !(1...limit).contains(page) {
        print("[⚠️] 로컬 범위 검증 실패: \(page) not in 1...\(limit)")
        await MainActor.run {
          self.errorMessage = "페이지는 1-\(limit) 사이여야 합니다."
        }
        return
      }
      if let limit = maxPage {
        print("[✅] 로컬 범위 검증 통과: \(page) in 1...\(limit)")
      } else {
        print("[ℹ️] maxPage가 아직 로드되지 않음 (검증 건너뛰기)")
      }
      
      // 4) ID 결정 및 모델 생성
      let id: String
      let isbn = self.record.isbn
      switch mode {
      case .create:
        id = UUID().uuidString
        print("[ℹ️] 생성 모드: 새로운 id=\(id)")
      case .edit(_, let quote):
        id = quote.id
        print("[ℹ️] 수정 모드: 기존 id=\(id)")
      }
      let model = Quote(id: id, isbn: isbn, content: trimmed, page: page)
      let recordEntity = self.record.toEntity(memos: [], quotes: [])
      // 5) 제출 상태 갱신
      await MainActor.run {
        self.isSubmitting = true
        self.errorMessage = nil
      }
      defer {
        Task { await MainActor.run { self.isSubmitting = false } }
      }
      print("[ℹ️] isSubmitting = true")
      // 6) UseCase 호출
      do {
        switch mode {
        case .create:
          print("[ℹ️] QuoteUseCase.addQuote 호출 시도")
          try await quoteUseCase.addQuote(model, in: recordEntity)
          print("[✅] addQuote 성공")
          await print(try quoteUseCase.fetchAllQuotes())
        case .edit:
          print("[ℹ️] QuoteUseCase.updateQuote 호출 시도")
          try await quoteUseCase.updateQuote(model)
          print("[✅] updateQuote 성공")
        }
        // 성공 시점에 didSubmitSuccess를 true로 변경
        await MainActor.run {
          self.didSubmitSuccess = true
          
        }
        print("[🎉] didSubmitSuccess = true")
      } catch {
        print("[❌] UseCase 호출 중 에러 발생:", error.localizedDescription)
        await MainActor.run {
          self.errorMessage = error.localizedDescription
        }
      }
    }
  }
}
