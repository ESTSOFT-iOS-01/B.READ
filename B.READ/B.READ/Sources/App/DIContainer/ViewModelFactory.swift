//
//  ViewModelFactory.swift
//  B.READ
//
//  Created by 김도연 on 6/11/25.
//

import Foundation

final class ViewModelFactory {
  static let shared = ViewModelFactory()
  private init() {}
  
  // MARK: - Search
  func createScan() -> ScanViewModel {
    ScanViewModel()
  }
  
  func createBook(isbn: String) -> BookViewModel {
    BookViewModel(isbn: isbn)
  }
  
  // MARK: - Library
  func createRecordDetail(id: String) -> RecordDetailViewModel {
    RecordDetailViewModel(recordID: id)
  }
  
  func createSummary(record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) -> SummaryViewModel {
    SummaryViewModel(record: record, memos: memos, quotes: quotes)
  }
  
  func createSummaryDetail(id: String, record: RecordDetailVO, memos: [MemoVO], quotes: [QuoteVO]) -> SummaryViewModel {
    SummaryViewModel(id: id, record: record, memos: memos, quotes: quotes)
  }
  
  // MARK: - Sentence
  func createSentenceInput(mode: SentenceInputMode) -> SentenceInputViewModel {
    SentenceInputViewModel(mode: mode)
  }
  
  func createPageInput(record: RecordDetailVO, quote: QuoteVO) -> PageInputViewModel {
    PageInputViewModel(record: record, quote: quote)
  }
  
  // MARK: - Memo
  func createMemo(id: String?, record: RecordDetailVO) -> MemoViewModel {
    MemoViewModel(id: id, record: record)
  }
  
  // MARK: - NewRecord
  func createNewRecord(book: Book) -> NewRecordViewModel {
    NewRecordViewModel(book: book)
  }
  
  func createUpdateRecord(record: RecordDetailVO) -> NewRecordViewModel {
    NewRecordViewModel(recordVO: record)
  }
}
