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

//@MainActor
final class SentenceInputViewModel: ObservableObject {
  
  // MARK: - State
  @Published var content: String = "" // 작성한 내용
  
  // MARK: - Internal Variables
  private let mode: SentenceInputMode
  let record: RecordDetailVO
  private(set) var quote: QuoteVO
  var trimmedContent: String {
    content.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  // MARK: - Initializer
  init(mode: SentenceInputMode) {
    self.mode = mode
    
    switch mode {
    case .create(let record):
      self.record = record
      self.quote = QuoteVO(
        id: UUID().uuidString,
        isbn: record.isbn,
        content: "",
        page: 0,
        record: record
      )

    case .edit(let record, let quote):
      self.record = record
      self.quote = quote
      self.content = quote.content
    }
  }
  
  // MARK: - Actions
  enum Action {
    case submit
  }
  
  func send(_ action: Action) {
    switch action {
    case .submit:
      /// 다음 버튼을 누르면 현재까지 작성한 trim String을 Quote에 저장
      self.quote.content = trimmedContent
    }
  }
}
